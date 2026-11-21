/**
 * `sienna.field3d` — a field in 3D: a grid of ground patches and a population
 * of trees standing on it, drawn with three.js and played back as a
 * time-lapse (Robert, 2026-11-21: "a bit of glitz", for teaching and for
 * public engagement; the agroforestry model first).
 *
 * ## What it shows
 *
 *   - THE GROUND: a fixed-membership submodel's instances as square patches,
 *     each coloured from dry straw to lush green and raised by one of its
 *     variables (pasture biomass), placed by two more (its centre, `px`,
 *     `py`) — or, without those, as a square grid. The patches sit on a slab
 *     of soil whose layers show at its edges.
 *   - THE TREES: a population's members as low-poly trees at (x, y), as tall
 *     as their size, their crowns as wide as a crown-radius variable if there
 *     is one (else 0.3 x height).
 *   - THE SUN is straight overhead, so each crown's shadow falls directly
 *     beneath it: the shade a model with a vertical sun computes.
 *
 * The variables are guessed from their names (Pasture, px, py; x, y, Height
 * or size, crown_radius) and can be chosen under "choose"; they are kept by
 * name, as the plotter keeps its.
 *
 * ## Time-lapse
 *
 * A run in the page takes a moment, far quicker than anyone can watch, so
 * every frame the run sends is KEPT (a new run — time going back — starts
 * afresh), and ▶ plays them back over about fifteen seconds, trees growing,
 * smoothly in between frames. The slider scrubs. While no playback is going
 * the picture follows the run, so a slider moved shows its outcome at once.
 *
 * ## Loading
 *
 * three.js r147 (`vendor/three/`: the last release with a classic-script
 * build and classic-script OrbitControls, so it needs no bundler), loaded
 * when the first of these opens, from beside this script. Model x and y are
 * three's x and z; y is up.
 *
 * Classic script, injected on demand by the widget registry.
 */
(function () {
  'use strict';

  var me = document.currentScript;
  var BASE = me && me.src ? me.src.replace(/src\/widgets\/[^/]*$/, '') : '';
  var threeLoading = null;

  function loadScript(src) {
    return new Promise(function (resolve, reject) {
      var s = document.createElement('script');
      s.src = src;
      s.onload = resolve;
      s.onerror = function () { reject(new Error('could not load ' + src)); };
      (document.head || document.documentElement).appendChild(s);
    });
  }

  /** three.js and its orbit controls, once per page. */
  function loadThree() {
    if (window.THREE && window.THREE.OrbitControls) return Promise.resolve(window.THREE);
    if (!threeLoading) {
      threeLoading = (window.THREE ? Promise.resolve() : loadScript(BASE + 'vendor/three/three.min.js'))
        .then(function () { return loadScript(BASE + 'vendor/three/OrbitControls.js'); })
        .then(function () { return window.THREE; })
        .catch(function (e) { threeLoading = null; throw e; });
    }
    return threeLoading;
  }

  // The choices: what each is for, and the names guessed first.
  var GROUND = [
    ['ground', 'Ground: colour and height', ['Pasture', 'pasture', 'biomass']],
    ['gx', 'Ground: patch centre, across', ['px', 'patch_x', 'x']],
    ['gy', 'Ground: patch centre, front to back', ['py', 'patch_y', 'y']],
  ];
  var TREES = [
    ['tx', 'Trees: where, across', ['x']],
    ['ty', 'Trees: where, front to back', ['y']],
    ['tsize', 'Trees: height', ['Height', 'height', 'size', 'Size']],
    ['tcrown', 'Trees: crown radius (optional)', ['crown_radius', 'crown']],
  ];
  var ROLES = GROUND.concat(TREES);
  var OPTIONAL = { gx: true, gy: true, tcrown: true };
  var MAX_FRAMES = 2000;

  var COLOURS = {
    sky: 0xcfe4f2, dry: 0xcdb77a, lush: 0x4f9a3c, topsoil: 0x4a3524, subsoil: 0x8a6a45,
    trunk: 0x7a4f2e, crown: 0x2f7a35,
  };

  var tail = function (label) { return String(label).split('/').pop(); };

  $.widget('sienna.field3d', $.sienna.widgetBase, {
    options: {
      ground: '', gx: '', gy: '', tx: '', ty: '', tsize: '', tcrown: '',
      /** Seconds a whole run takes to play back. */
      playSeconds: 15,
    },

    _create: function () {
      var self = this;
      this.element.addClass('slx-field3d');
      this._sim = Sienna.Simulation.viewFor(this._ref());
      this._owner = this._panelId() || ('f3d' + Math.random().toString(36).slice(2));
      this._ids = {};
      this._frames = [];
      this._head = 0;              // the frame shown: a fraction between frames while playing
      this._playing = false;
      this._alive = true;

      this._buildBar();
      this._view = $('<div class="slx-field3d-view">').appendTo(this.element);
      this._note = $('<div class="slx-field3d-note">').text('Loading the 3D view…').appendTo(this._view);
      this._clock = $('<div class="slx-field3d-clock" hidden>').appendTo(this._view);

      this._unsub = this._sim.subscribe(function (e) { self._onEvent(e); });
      this._watchModel(function () {
        window.clearTimeout(self._listTimer);
        self._listTimer = window.setTimeout(function () { self._syncComponents(); }, 250);
      });

      loadThree().then(function (THREE) {
        if (!self._alive) return;
        self._T = THREE;
        try { self._buildScene(); } catch (e) {
          self._note.text('This display needs WebGL, which this browser has turned off.').show();
          return;
        }
        self._syncComponents();
      }, function (e) { self._note.text(e.message).show(); });
    },

    // ---- the bar ---------------------------------------------------------

    _buildBar: function () {
      var self = this;
      var bar = $('<div class="slx-palette slx-chrome slx-field3d-bar">').appendTo(this.element);
      this._play = $('<button type="button" class="slx-field3d-play">').text('▶')
        .attr('title', 'Play the run back as a time-lapse').appendTo(bar);
      this._scrub = $('<input type="range" min="0" max="0" step="0.01" value="0" class="slx-field3d-scrub">')
        .attr('title', 'Move through the run').appendTo(bar);
      this._tour = $('<button type="button">').text('tour')
        .attr('title', 'Fly slowly round the field').appendTo(bar);
      this._chooseBtn = $('<button type="button">').text('choose')
        .attr('title', 'Which variables are shown').appendTo(bar);
      $('<button type="button">').text('reset view').attr('title', 'Back to the starting view')
        .appendTo(bar).on('click', function () { self._homeCamera(); });

      this._choices = $('<div class="slx-palette slx-chrome slx-field3d-choices" hidden>').appendTo(this.element);
      this._picks = {};
      ROLES.forEach(function (r) {
        var wrap = $('<label class="slx-field3d-pick">').attr('title', r[1]).appendTo(self._choices);
        $('<span>').text(r[1]).appendTo(wrap);
        self._picks[r[0]] = $('<select>').appendTo(wrap).on('change', function () {
          var c = self._byId[self._picks[r[0]].val()];
          self.options[r[0]] = c ? c.label : '';
          self._bind();
        });
      });

      this._play.on('click', function () { self._playing ? self._stop() : self._start(); });
      this._scrub.on('input', function () {
        self._stop();
        self._head = Number(self._scrub.val());
        self._showHead();
      });
      this._tour.on('click', function () {
        if (!self._controls) return;
        self._controls.autoRotate = !self._controls.autoRotate;
        self._tour.toggleClass('slx-on', self._controls.autoRotate);
      });
      this._chooseBtn.on('click', function () {
        self._choices.prop('hidden', !self._choices.prop('hidden'));
        self._resize();
      });
    },

    // ---- the scene -------------------------------------------------------

    _buildScene: function () {
      var THREE = this._T, self = this;
      var renderer = new THREE.WebGLRenderer({ antialias: true, preserveDrawingBuffer: true });
      renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2));
      renderer.shadowMap.enabled = true;
      renderer.shadowMap.type = THREE.PCFSoftShadowMap;
      this._renderer = renderer;
      $(renderer.domElement).addClass('slx-field3d-canvas').prependTo(this._view);

      var scene = new THREE.Scene();
      scene.background = new THREE.Color(COLOURS.sky);
      this._scene = scene;
      scene.add(new THREE.HemisphereLight(0xeef7ff, 0x6b5a40, 0.55));
      var side = new THREE.DirectionalLight(0xfff4e0, 0.22);   // modelling only: no shadow
      side.position.set(1, 0.8, 0.6);
      scene.add(side);
      var sun = new THREE.DirectionalLight(0xffffff, 0.62);    // straight down: the model's sun
      sun.castShadow = true;
      sun.shadow.mapSize.set(2048, 2048);
      sun.shadow.bias = -0.0004;
      scene.add(sun);
      scene.add(sun.target);
      this._sun = sun;

      this._camera = new THREE.PerspectiveCamera(38, 1, 0.3, 5000);
      var controls = new THREE.OrbitControls(this._camera, renderer.domElement);
      controls.enableDamping = true;
      controls.dampingFactor = 0.08;
      controls.maxPolarAngle = Math.PI * 0.495;
      controls.autoRotateSpeed = 0.6;
      this._controls = controls;

      this._fieldGroup = new THREE.Group();
      scene.add(this._fieldGroup);
      this._field = null;                     // { x0, x1, z0, z1, cell } once known
      this._patchMesh = null;
      this._trunks = null;
      this._crowns = null;

      this._ro = window.ResizeObserver ? new ResizeObserver(function () { self._resize(); }) : null;
      if (this._ro) this._ro.observe(this._view[0]);
      this._watchPanelResize(function () { self._resize(); });
      this._resize();

      var last = performance.now();
      var loop = function (now) {
        if (!self._alive) return;
        self._raf = window.requestAnimationFrame(loop);
        var dt = Math.min(0.1, (now - last) / 1000);
        last = now;
        if (self._playing) self._advance(dt);
        var moved = controls.update();
        if (moved || self._dirty || controls.autoRotate) {
          self._dirty = false;
          renderer.render(scene, self._camera);
        }
      };
      this._raf = window.requestAnimationFrame(loop);
      this._note.hide();
    },

    _resize: function () {
      if (!this._renderer) return;
      var w = this._view.width(), h = this._view.height();
      if (!w || !h) return;
      this._renderer.setSize(w, h);
      this._camera.aspect = w / h;
      this._camera.updateProjectionMatrix();
      this._dirty = true;
    },

    /** The field's extent, from the patch centres, or the trees, or 0–100. */
    _fitField: function (frame) {
      var gx = frame.gx, gy = frame.gy, n = frame.ground ? frame.ground.length : 0;
      var f;
      var lo = function (a) { return Math.min.apply(null, a); };
      var hi = function (a) { return Math.max.apply(null, a); };
      // Patch centres, when they say something: before the model's first
      // step they may all still be 0.
      if (gx && gy && gx.length === n && n && hi(gx) > lo(gx) && hi(gy) > lo(gy)) {
        var xs = Array.from(new Set(Array.from(gx))).sort(function (a, b) { return a - b; });
        var cell = xs[1] - xs[0];
        f = { x0: lo(gx) - cell / 2, x1: hi(gx) + cell / 2, z0: lo(gy) - cell / 2, z1: hi(gy) + cell / 2, cell: cell };
      } else if (n) {
        var side = Math.ceil(Math.sqrt(n));
        var size = 100, cellSq = size / side;
        f = { x0: 0, x1: size, z0: 0, z1: size, cell: cellSq, square: side };
      } else {
        f = { x0: 0, x1: 100, z0: 0, z1: 100, cell: 5 };
      }
      f.cx = (f.x0 + f.x1) / 2;
      f.cz = (f.z0 + f.z1) / 2;
      f.size = Math.max(f.x1 - f.x0, f.z1 - f.z0);
      return f;
    },

    /** Ground, soil and the tree meshes for a field of this extent and patch count. */
    _buildField: function (f, n) {
      var THREE = this._T, g = this._fieldGroup;
      while (g.children.length) {
        var c = g.children.pop();
        if (c.geometry) c.geometry.dispose();
        if (c.material) c.material.dispose();
      }
      var w = f.x1 - f.x0, d = f.z1 - f.z0;
      var soil = function (top, bottom, colour) {
        var m = new THREE.Mesh(new THREE.BoxGeometry(w, top - bottom, d),
          new THREE.MeshLambertMaterial({ color: colour }));
        m.position.set(0, (top + bottom) / 2, 0);
        m.receiveShadow = true;
        g.add(m);
      };
      var depth = Math.max(3, f.size * 0.05);
      soil(0, -depth * 0.3, COLOURS.topsoil);
      soil(-depth * 0.3, -depth, COLOURS.subsoil);

      if (n) {
        var mat = new THREE.MeshLambertMaterial({ color: 0xffffff });
        this._patchMesh = new THREE.InstancedMesh(new THREE.BoxGeometry(1, 1, 1), mat, n);
        this._patchMesh.receiveShadow = true;
        this._patchMesh.instanceColor = new THREE.InstancedBufferAttribute(new Float32Array(n * 3), 3);
        g.add(this._patchMesh);
      } else {
        this._patchMesh = null;
      }
      this._treeCapacity = 0;
      this._ensureTrees(256);

      var sun = this._sun, half = f.size * 0.6;
      sun.position.set(0, f.size * 2, 0.0001);
      sun.target.position.set(0, 0, 0);
      var cam = sun.shadow.camera;
      cam.left = -half; cam.right = half; cam.top = half; cam.bottom = -half;
      cam.near = 1; cam.far = f.size * 4;
      cam.updateProjectionMatrix();
      this._scene.fog = new THREE.Fog(COLOURS.sky, f.size * 2.5, f.size * 6);
      this._field = f;
      this._fieldN = n;
      this._homeCamera();
    },

    _ensureTrees: function (count) {
      if (count <= this._treeCapacity) return;
      var THREE = this._T, g = this._fieldGroup;
      var cap = Math.max(256, this._treeCapacity * 2);
      while (cap < count) cap *= 2;
      [this._trunks, this._crowns].forEach(function (m) {
        if (m) { g.remove(m); m.geometry.dispose(); m.material.dispose(); }
      });
      var trunkGeo = new THREE.CylinderGeometry(0.6, 1, 1, 7);
      trunkGeo.translate(0, 0.5, 0);                       // base at the ground
      this._trunks = new THREE.InstancedMesh(trunkGeo, new THREE.MeshLambertMaterial({ color: COLOURS.trunk }), cap);
      var crownGeo = new THREE.IcosahedronGeometry(1, 1);
      this._crowns = new THREE.InstancedMesh(crownGeo,
        new THREE.MeshLambertMaterial({ color: 0xffffff, flatShading: true }), cap);
      this._crowns.instanceColor = new THREE.InstancedBufferAttribute(new Float32Array(cap * 3), 3);
      [this._trunks, this._crowns].forEach(function (m) {
        m.castShadow = true; m.receiveShadow = true; m.count = 0; g.add(m);
      });
      this._treeCapacity = cap;
    },

    _homeCamera: function () {
      if (!this._camera || !this._field) return;
      var s = this._field.size;
      this._camera.position.set(s * 0.66, s * 0.58, s * 0.92);
      this._controls.target.set(0, 0, 0);
      this._controls.update();
      this._dirty = true;
    },

    // ---- choosing the variables -----------------------------------------

    /** Values per instance of a fixed-membership submodel: dims [n, 0]. */
    _arrayComponents: function () {
      var comps = this._sim.components || {};
      return Object.keys(comps).filter(function (id) {
        var c = comps[id], dims = c.dims || [];
        return c.type !== 'VALUELESS' && dims.length === 2 && typeof dims[0] === 'number' && dims[0] > 1;
      }).map(function (id) {
        return { id: id, label: String(comps[id].captpath || id).replace(/^\//, ''), kind: 'array' };
      });
    },

    _syncComponents: function () {
      var self = this;
      if (!this._renderer) return;
      var arrays = this._arrayComponents();
      var members = (this._sim.memberComponents ? this._sim.memberComponents() : [])
        .map(function (c) { return { id: c.id, label: c.label, kind: 'member' }; });
      this._byId = {};
      arrays.concat(members).forEach(function (c) { self._byId[c.id] = c; });

      var pickFrom = function (list, role, names) {
        var wanted = self.options[role];
        var found = wanted && (list.find(function (c) { return c.label === wanted; })
          || list.find(function (c) { return tail(c.label) === tail(wanted); }));
        for (var i = 0; !found && i < names.length; i++) {
          found = list.find(function (c) { return tail(c.label) === names[i]; });
        }
        return found;
      };
      var fill = function (role, list, names) {
        var pick = self._picks[role].empty();
        $('<option>').val('').text(list.length ? (OPTIONAL[role] ? '(none)' : 'select…')
          : (self._sim.base ? '(none in this model)' : '(no model loaded)')).appendTo(pick);
        list.slice().sort(function (a, b) { return a.label.localeCompare(b.label); }).forEach(function (c) {
          $('<option>').val(c.id).text(c.label).appendTo(pick);
        });
        var c = pickFrom(list, role, names);
        pick.val(c ? c.id : '');
        if (c) self.options[role] = c.label;
      };
      GROUND.forEach(function (r) { fill(r[0], arrays, r[2]); });
      TREES.forEach(function (r) { fill(r[0], members, r[2]); });
      this._bind();
    },

    _bind: function () {
      var self = this;
      ROLES.forEach(function (r) {
        var id = self._picks[r[0]].val() || null;
        self._ids[r[0]] = id;
        if (id) self._sim.addTarget(self._owner + ':' + r[0], id);
        else self._sim.removeTarget(self._owner + ':' + r[0]);
      });
      this._frames = [];
      this._field = null;
      this._stop();
      var ids = ROLES.map(function (r) { return self._ids[r[0]]; }).filter(Boolean);
      if (!ids.length || !this._sim.base) { this._showMessage(); return; }
      this._sim.query(ids).then(function (values) {
        if (self._frames.length) return;            // the model has stepped since
        self._take(Number(self._sim.settings.current), values);
      }).catch(function () { /* drawn when the model next steps */ });
    },

    // ---- data -------------------------------------------------------------

    _onEvent: function (e) {
      if (!this._renderer) return;
      if (e.type === 'describe') this._syncComponents();
      else if (e.type === 'data') this._take(e.time, e.values);
      else if (e.type === 'status' && !this._sim.base) { this._frames = []; this._syncComponents(); }
    },

    /** Keep a frame; a new run (time going back) starts the record afresh. */
    _take: function (t, values) {
      var ids = this._ids;
      var arr = function (id) {
        var v = id && values[id];
        return Array.isArray(v) ? Float32Array.from(v, Number) : null;
      };
      var obj = function (id) { var v = id && values[id]; return v && typeof v === 'object' && !Array.isArray(v) ? v : {}; };
      var frame = { t: Number(t), ground: arr(ids.ground), gx: arr(ids.gx), gy: arr(ids.gy), trees: [] };
      var xs = obj(ids.tx), ys = obj(ids.ty), ss = obj(ids.tsize), cs = obj(ids.tcrown);
      Object.keys(ss).forEach(function (k) {
        var x = Number(xs[k]), y = Number(ys[k]), s = Number(ss[k]);
        if (!isFinite(x) || !isFinite(y) || !isFinite(s)) return;
        var c = Number(cs[k]);
        frame.trees.push({ k: k, x: x, y: y, s: s, r: isFinite(c) ? c : 0.3 * s });
      });
      var last = this._frames[this._frames.length - 1];
      if (last && frame.t < last.t - 1e-9) { this._frames = []; this._stop(); }
      else if (last && Math.abs(frame.t - last.t) < 1e-9) this._frames.pop();
      if (!frame.gx && last) { frame.gx = last.gx; frame.gy = last.gy; }
      // A frame whose patch centres have not been computed yet takes the
      // next one's (drawn with them, not piled at 0).
      if (frame.gx && last && last.gx && Math.max.apply(null, last.gx) === Math.min.apply(null, last.gx)) {
        this._frames.forEach(function (fr) { fr.gx = frame.gx; fr.gy = frame.gy; });
      }
      this._frames.push(frame);
      if (this._frames.length > MAX_FRAMES) {
        this._frames = this._frames.filter(function (f, i, a) { return i % 2 === 0 || i === a.length - 1; });
      }
      var fit = this._fitField(frame), had = this._field;
      if (!had || (frame.ground ? frame.ground.length : 0) !== this._fieldN
          || ['x0', 'x1', 'z0', 'z1', 'cell'].some(function (k) { return Math.abs(fit[k] - had[k]) > 1e-9; })) {
        this._buildField(fit, frame.ground ? frame.ground.length : 0);
      }
      this._groundMax = Math.max(this._groundMax || 0, frame.ground ? Math.max.apply(null, frame.ground) : 0);
      this._scrub.attr('max', Math.max(0, this._frames.length - 1));
      if (!this._playing) {
        this._head = this._frames.length - 1;
        this._scrub.val(this._head);
        this._showHead();
      }
      this._showMessage();
    },

    _showMessage: function () {
      var missing = [];
      if (!this._ids.ground && !this._ids.tsize) missing.push('nothing to show: choose the ground or the trees');
      if (!this._sim.base) missing = ['Run the model to see its field.'];
      this._note.text(missing.join('; ')).toggle(!!missing.length && !this._frames.length);
    },

    // ---- playback -----------------------------------------------------------

    _start: function () {
      if (this._frames.length < 2) return;
      if (this._head >= this._frames.length - 1) this._head = 0;
      this._playing = true;
      this._play.text('❚❚').attr('title', 'Pause');
    },

    _stop: function () {
      this._playing = false;
      if (this._play) this._play.text('▶').attr('title', 'Play the run back as a time-lapse');
    },

    _advance: function (dt) {
      var n = this._frames.length;
      if (n < 2) { this._stop(); return; }
      this._head += dt * (n - 1) / Math.max(1, this.options.playSeconds);
      if (this._head >= n - 1) { this._head = n - 1; this._stop(); }
      this._scrub.val(this._head);
      this._showHead();
    },

    /** Draw the frame at the play head, blending two frames between them. */
    _showHead: function () {
      var frames = this._frames;
      if (!frames.length || !this._field) return;
      var i = Math.max(0, Math.min(frames.length - 1, Math.floor(this._head)));
      var j = Math.min(frames.length - 1, i + 1);
      var u = this._head - i;
      this._drawFrame(frames[i], frames[j], u);
    },

    _drawFrame: function (a, b, u) {
      var THREE = this._T, f = this._field;
      var lerp = function (p, q) { return p + (q - p) * u; };
      var m = new THREE.Matrix4(), q = new THREE.Quaternion(), pos = new THREE.Vector3(), sc = new THREE.Vector3();
      var col = new THREE.Color(), dry = new THREE.Color(COLOURS.dry), lush = new THREE.Color(COLOURS.lush);

      // The ground.
      var mesh = this._patchMesh;
      if (mesh && a.ground) {
        var top = this._groundMax || 1, cell = f.cell * 0.985, n = a.ground.length;
        for (var i = 0; i < n; i++) {
          var v = b.ground ? lerp(a.ground[i], b.ground[i]) : a.ground[i];
          var k = Math.max(0, Math.min(1, v / top));
          var h = f.cell * 0.04 + k * f.cell * 0.45;
          var x, z;
          if (a.gx && a.gy) { x = a.gx[i] - f.cx; z = a.gy[i] - f.cz; }
          else { x = f.x0 + ((i % f.square) + 0.5) * f.cell - f.cx; z = f.z0 + (Math.floor(i / f.square) + 0.5) * f.cell - f.cz; }
          pos.set(x, h / 2, z); sc.set(cell, h, cell);
          mesh.setMatrixAt(i, m.compose(pos, q, sc));
          col.copy(dry).lerp(lush, Math.pow(k, 0.8));
          mesh.setColorAt(i, col);
        }
        mesh.instanceMatrix.needsUpdate = true;
        mesh.instanceColor.needsUpdate = true;
      }

      // The trees: those in both frames grow smoothly; one felled or planted
      // between them goes or comes halfway.
      var bk = {};
      b.trees.forEach(function (t) { bk[t.k] = t; });
      var shown = [];
      a.trees.forEach(function (t) {
        var t2 = bk[t.k];
        if (t2) shown.push({ k: t.k, x: lerp(t.x, t2.x), y: lerp(t.y, t2.y), s: lerp(t.s, t2.s), r: lerp(t.r, t2.r) });
        else if (u < 0.5) shown.push(t);
      });
      if (u >= 0.5) {
        var ak = {};
        a.trees.forEach(function (t) { ak[t.k] = true; });
        b.trees.forEach(function (t) { if (!ak[t.k]) shown.push(t); });
      }
      this._ensureTrees(shown.length);
      var trunks = this._trunks, crowns = this._crowns;
      shown.forEach(function (t, idx) {
        var s = Math.max(0.05, t.s), r = Math.max(0.05, t.r);
        var trunkH = s * 0.62, trunkR = Math.max(0.04, s * 0.022);
        var vert = Math.max(0.15, s * 0.22);
        pos.set(t.x - f.cx, 0, t.y - f.cz); sc.set(trunkR, trunkH, trunkR);
        trunks.setMatrixAt(idx, m.compose(pos, q, sc));
        pos.set(t.x - f.cx, s - vert, t.y - f.cz); sc.set(r, vert, r);
        crowns.setMatrixAt(idx, m.compose(pos, q, sc));
        // A little variety by member: no two trees quite the same green.
        var hash = 0, key = String(t.k);
        for (var c = 0; c < key.length; c++) hash = (hash * 31 + key.charCodeAt(c)) >>> 0;
        col.setHex(COLOURS.crown).offsetHSL(((hash % 13) - 6) / 300, ((hash % 7) - 3) / 60, ((hash % 11) - 5) / 140);
        crowns.setColorAt(idx, col);
      });
      trunks.count = crowns.count = shown.length;
      trunks.instanceMatrix.needsUpdate = true;
      crowns.instanceMatrix.needsUpdate = true;
      if (crowns.instanceColor) crowns.instanceColor.needsUpdate = true;

      var t = lerp(a.t, b.t);
      this._clock.prop('hidden', false).text('time ' + (Math.round(t * 10) / 10) + '   ·   ' + shown.length + ' trees');
      this._dirty = true;
    },

    // ---- life -----------------------------------------------------------------

    _destroy: function () {
      var self = this;
      this._alive = false;
      if (this._unsub) this._unsub();
      if (this._ro) this._ro.disconnect();
      if (this._raf) window.cancelAnimationFrame(this._raf);
      ROLES.forEach(function (r) { self._sim.removeTarget(self._owner + ':' + r[0]); });
      if (this._controls) this._controls.dispose();
      if (this._renderer) { this._renderer.dispose(); this._renderer.forceContextLoss(); }
      this.element.removeClass('slx-field3d').empty();
    },

    /** View state: the chosen variables, by name. */
    state: function () {
      var self = this, s = {};
      ROLES.forEach(function (r) { s[r[0]] = self.options[r[0]]; });
      return s;
    },
  });

  window.Sienna.widgetRegistry._loaded('field3d', 'field3d');
})();
