/**
 * `Sienna.remote` — a model fetched from an address: the one way the app
 * (`index.html?open=…`, `openFromAddress` in main.js) and embedded-widget
 * pages (`Simile.model(name, '<address>.json')`, page.js) get a model from
 * the web, e.g. from the model gallery's site.
 *
 * What is fetched is the model spec, the file File ▸ Save writes: plain
 * JSON, data that is never run. Its parameter values come from a parameter
 * file (`<model>.parameters.json`, what the Parameters panel's Save
 * writes): the one at the address given, else the one beside the model, if
 * there is one.
 *
 * This is the one exception to "no fetch" (CLAUDE.md): a page opened from
 * disk cannot fetch a file beside it, but it can fetch from a web site that
 * allows other sites to read its files (CORS; GitHub Pages does, for every
 * file). So every message here says which of those went wrong.
 *
 * Classic script; no imports/exports.
 */
(function (Sienna) {
  'use strict';

  var TIMEOUT = 30000;   // ms

  /** An address made absolute, from where this page is; throws if it is not one. */
  function absolute(address, from) {
    try {
      return new URL(address, from || window.location.href).href;
    } catch (e) {
      throw new Error('"' + address + '" is not an address');
    }
  }

  /**
   * A Promise of the text at `url`, or a rejection saying why not, in words.
   * `quiet`: a file that may well not be there (a parameter file looked for
   * beside a model) fails with no explanation, since none will be shown.
   */
  function text(url, quiet) {
    var ctl = window.AbortController ? new AbortController() : null;
    var timer = ctl && setTimeout(function () { ctl.abort(); }, TIMEOUT);
    var done = function () { if (timer) clearTimeout(timer); };
    return fetch(url, ctl ? { signal: ctl.signal } : {}).then(function (r) {
      done();
      if (!r.ok) {
        throw new Error(r.status === 404 ? 'there is no file at that address'
          : 'the site answered ' + r.status + (r.statusText ? ' (' + r.statusText + ')' : ''));
      }
      return r.text();
    }, function () {
      done();
      throw new Error(quiet ? 'unreachable'
        : /^file:/.test(url)
          ? 'a page opened from disk can fetch only from a web address (https://…), not a file on this computer'
          : 'it could not be reached: no connection, or the site does not allow other sites to read its files');
    });
  }

  /** Where a model's own parameter file would be: `<model>.parameters.json` beside it. */
  function parametersBeside(url) {
    return url.replace(/[?#].*$/, '').replace(/(\.json)?$/i, '.parameters.json');
  }

  Sienna.remote = {
    absolute: absolute,
    text: text,
    parametersBeside: parametersBeside,

    /**
     * Fetch a model and its parameter file.
     * @param {string} address — of the model's .json (relative to this page)
     * @param {string} [parameters] — of its parameter file (relative to the
     *   model); without one, `<name>.parameters.json` beside the model is used
     *   if it is there
     * @returns {Promise<{url, model, parameters: object|null, parametersAt, problem}>}
     *   `parameters` the parsed file, or null; `problem` why a parameter file
     *   that was named, or found, could not be used. Rejects, in words, when
     *   the model itself cannot be had.
     */
    model: function (address, parameters) {
      var url;
      try { url = absolute(address); } catch (e) { return Promise.reject(e); }
      return text(url).then(function (body) {
        var model;
        try { model = JSON.parse(body); } catch (e) {
          throw new Error('the file there is not a model (it is not JSON)');
        }
        if (!model || typeof model !== 'object' || !model.nodes || !model.arcs) {
          throw new Error('the file there is not a model (no nodes and arcs)');
        }
        var out = { url: url, model: model, parameters: null, parametersAt: null, problem: null };
        var at;
        try { at = parameters ? absolute(parameters, url) : parametersBeside(url); } catch (e) {
          out.problem = e.message;
          return out;
        }
        if (at === url) return out;
        return text(at, !parameters).then(function (body2) {
          out.parametersAt = at;
          try { out.parameters = JSON.parse(body2); } catch (e) {
            out.problem = 'the parameter file at ' + at + ' is not JSON, so it was not used';
          }
          return out;
        }, function (e) {
          if (parameters) out.problem = 'the parameter file at ' + at + ' could not be used: ' + e.message;
          return out;
        });
      });
    },
  };
})(window.Sienna);
