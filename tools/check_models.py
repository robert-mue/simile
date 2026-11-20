#!/usr/bin/env python3
"""Check that models build and run in the app, and optionally that converted
Vensim models give the same results as their Vensim originals.

Run it from the simile folder (cd ~/Projects/simile). Examples:

  python3 tools/check_models.py
        every model in the model gallery (~/Projects/model_gallery/models)

  python3 tools/check_models.py ~/Projects/model_gallery/models/trees/trees.json
        one model file

  python3 tools/check_models.py "~/Projects/vensim_models/Simile JSON"
        every model in a folder (and the folders inside it); a name with
        spaces goes in "quotes"

  python3 tools/check_models.py "~/Projects/vensim_models/Simile JSON" --only EZ101,EZ206
        only the models whose file names start so

  python3 tools/check_models.py "~/Projects/vensim_models/Simile JSON" --vensim "~/Projects/vensim_models/ZOO MDL"
        and compare each with the Vensim original of the same name

  python3 tools/check_models.py --save
        check the gallery, and record each model's values at the end of its
        run as the right ones (in check-expected.json, in the simile folder)

Once a model's values are recorded, every later check compares its values
with them: SAME, or CHANGED with the values that changed. Record them again
(--save) after a change to a model that was meant to change its results.
A model that uses random numbers (rand_var, gaussian_var, ...) is compared
too: the engine starts its random numbers the same way each run, so its
values repeat. If one does change, the report says it uses random numbers.

Each model is read as File > Open reads it, checked for completeness
(red/black), exported to Simile's Prolog, compiled in the page and run with
its own run settings (tools/headless/scripts/model-file.py). With --vensim,
each model's .mdl is also run by an independent Vensim simulator
(tools/vensim/vensim_sim.py) and the values at the end of the run compared
(tools/vensim/compare.py). Everything goes into check-report.txt in the
current folder. About 10 seconds a model; Ctrl+C stops it.

It starts what it needs if it is not running already, the app's web server
(tools/serve.py, port 8731) and a hidden Chrome (port 9350), and stops
what it started when it is done.
"""
import argparse, json, os, re, shutil, socket, subprocess, sys, tempfile, time

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GALLERY = os.path.expanduser('~/Projects/model_gallery/models')
EXPECTED = os.path.join(REPO, 'check-expected.json')
RANDOM = re.compile(r'\b(rand|rand_var|rand_const|gaussian_var|exprnd|poidev|binome|hypergeom|with_colin)\s*\(')

ap = argparse.ArgumentParser(description='Check that models build and run in the app.',
                             epilog='Run with no arguments to check the model gallery.')
ap.add_argument('where', nargs='*', help='model files (.json) or folders of them (default: the model gallery)')
ap.add_argument('--only', help='only models whose file names start with one of these, comma-separated')
ap.add_argument('--vensim', metavar='MDL_FOLDER', help='also compare with the Vensim originals in this folder')
ap.add_argument('--save', action='store_true',
                help='record the values at the end of each run as the right ones (check-expected.json)')
ap.add_argument('--report', default='check-report.txt', help='where to write the report (default: check-report.txt)')
args = ap.parse_args()
REPORT = os.path.abspath(os.path.expanduser(args.report))


def say(text=''):
    print(text, flush=True)


def listening(port):
    with socket.socket() as s:
        s.settimeout(0.5)
        return s.connect_ex(('127.0.0.1', port)) == 0


def wait_for(port, what, seconds=20):
    for _ in range(seconds * 4):
        if listening(port):
            return
        time.sleep(0.25)
    sys.exit('Could not start %s (nothing answers on port %d).' % (what, port))


def find_chrome():
    for c in ('/opt/google/chrome/chrome', 'google-chrome', 'google-chrome-stable', 'chromium', 'chromium-browser'):
        p = c if os.path.isabs(c) and os.path.exists(c) else shutil.which(c)
        if p:
            return p
    sys.exit('Chrome was not found. Install Google Chrome, or start it as tools/headless/README.md says.')


def home(path):
    """A model's file as recorded: ~ for the home folder."""
    h = os.path.expanduser('~')
    return '~' + path[len(h):] if path.startswith(h + os.sep) else path


def same(a, b):
    try:
        a, b = float(a), float(b)
    except ValueError:
        return a == b
    return abs(a - b) <= max(1e-12, 1e-9 * max(abs(a), abs(b)))


def model_files(place):
    """A model spec, or every one in a folder and the folders inside it
    (not parameter files, nor the gallery's own list)."""
    place = os.path.abspath(os.path.expanduser(place))
    if os.path.isfile(place):
        return [place]
    if not os.path.isdir(place):
        sys.exit('No such file or folder: %s\n(a name with spaces goes in "quotes")' % place)
    found = []
    for d, _, names in os.walk(place):
        found += [os.path.join(d, n) for n in names
                  if n.endswith('.json') and not n.endswith('.parameters.json') and n != 'index.json']
    return sorted(found)


# ---- what to check ----------------------------------------------------------
files = []
for place in args.where or [GALLERY]:
    files += [f for f in model_files(place) if f not in files]
if args.only:
    starts = [s.strip() for s in args.only.split(',') if s.strip()]
    files = [f for f in files if any(os.path.basename(f).startswith(s) for s in starts)]
if not files:
    sys.exit('No model files (.json) to check.')
mdl_dir = os.path.abspath(os.path.expanduser(args.vensim)) if args.vensim else None
if mdl_dir and not os.path.isdir(mdl_dir):
    sys.exit('No such folder: %s\n(a name with spaces goes in "quotes")' % mdl_dir)
try:
    import websockets  # noqa: F401  (cdp.py needs it)
except ImportError:
    sys.exit('Python\'s "websockets" package is missing. Install it with:\n    pip3 install --user websockets')

say('Checking %d model%s%s\n' % (len(files), '' if len(files) == 1 else 's',
    ', compared with the Vensim originals in ' + mdl_dir if mdl_dir else ''))

# ---- start what is needed ---------------------------------------------------
started = []
work = tempfile.mkdtemp(prefix='simile-check-')
try:
    if not listening(8731):
        say('Starting the app\'s web server ...')
        started.append(subprocess.Popen([sys.executable, os.path.join(REPO, 'tools/serve.py')], cwd=REPO,
                                        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL))
        wait_for(8731, 'the web server')
    if not listening(9350):
        say('Starting a hidden Chrome ...')
        started.append(subprocess.Popen([find_chrome(), '--headless=new', '--remote-debugging-port=9350',
            '--user-data-dir=' + os.path.join(work, 'chrome'), '--window-size=1280,800', '--hide-scrollbars',
            '--noerrdialogs', '--no-first-run', '--ozone-platform=headless', '--use-angle=swiftshader-webgl',
            'about:blank'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL))
        wait_for(9350, 'Chrome')
        time.sleep(2)

    # ---- the app ------------------------------------------------------------
    say('Loading, checking, compiling and running each model in the app')
    say('(about 10 seconds a model; the first compile takes longer)\n')
    listing = os.path.join(work, 'models.txt')
    open(listing, 'w').write('\n'.join(files) + '\n')
    app_out = os.path.join(work, 'app-results.txt')
    n, passed, failed = 0, [], []
    values = {}                                   # model file -> {name: value}
    with open(app_out, 'w') as out:
        p = subprocess.Popen([sys.executable, os.path.join(REPO, 'tools/headless/cdp.py'),
                              os.path.join(REPO, 'tools/headless/scripts/model-file.py')],
                             cwd=REPO, env=dict(os.environ, MODEL_LIST=listing),
                             stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
        current = None
        for line in p.stdout:
            out.write(line)
            s = line.strip()
            if s.startswith('== ') and s.endswith('.json'):
                current = os.path.basename(s[3:-5]); n += 1
                cur_file = os.path.normpath(os.path.join(REPO, s[3:]))
                values[cur_file] = {}
                say('  [%d/%d] %s' % (n, len(files), current))
            elif s.startswith(('FAIL', 'JSERR', 'EXC', 'Traceback')):
                say('        ' + s)
                if current and current not in failed:
                    failed.append(current)
            elif 'PASS loads, complete, exports, runs' in s:
                passed.append(current)
            else:
                m = re.match(r'^\s+/(\S+) = (.*)$', line)
                if m and current:
                    values[cur_file][m.group(1)] = m.group(2).strip()
        p.wait()
    say('\n%d of %d passed: they load, are complete, export, compile and run.' % (len(passed), len(files)))
    missing = [os.path.basename(f)[:-5] for f in files
               if os.path.basename(f)[:-5] not in passed and os.path.basename(f)[:-5] not in failed]
    if failed:
        say('Problems in: ' + ', '.join(failed))
    if missing:
        say('Not checked (the check stopped early?): ' + ', '.join(missing))

    # ---- the recorded values ------------------------------------------------
    try:
        expected = json.load(open(EXPECTED))
    except (OSError, ValueError):
        expected = {}
    changed_text = []
    ok_names = set(passed)
    if expected:
        say('\nCompared with the values recorded as right (%s):' % os.path.basename(EXPECTED))
        n_same = n_new = 0
        for f in files:
            name, key = os.path.basename(f)[:-5], home(f)
            if name not in ok_names or key not in expected:
                n_new += key not in expected
                continue
            was, now = expected[key]['values'], values.get(f, {})
            diffs = ['%s was %s, now %s' % (k, was[k], now.get(k, 'missing')) for k in sorted(was)
                     if k not in now or not same(was[k], now[k])]
            diffs += ['%s new, %s' % (k, now[k]) for k in sorted(now) if k not in was]
            if diffs:
                if expected[key].get('random'):
                    name += ' (uses random numbers)'
                changed_text.append('CHANGED  %s: %s' % (name, '; '.join(diffs)))
                say('  CHANGED  %s: %d value%s: %s%s' % (name, len(diffs), '' if len(diffs) == 1 else 's',
                    '; '.join(diffs[:3]), ' ...' if len(diffs) > 3 else ''))
            else:
                n_same += 1
        say('  %d the same as recorded, %d changed%s' % (n_same, len(changed_text),
            ', %d not recorded yet' % n_new if n_new else ''))
    if args.save:
        for f in files:
            if os.path.basename(f)[:-5] in ok_names:
                expected[home(f)] = {'values': values.get(f, {}), 'saved': time.strftime('%Y-%m-%d %H:%M'),
                                     'random': bool(RANDOM.search(open(f).read()))}
        with open(EXPECTED, 'w') as e:
            json.dump(expected, e, indent=1, sort_keys=True)
        say('\nRecorded the values of the %d that passed as the right ones, in %s' % (len(ok_names), EXPECTED))
    elif not expected:
        say('\n(No values recorded yet: add --save to record these as the right ones.)')

    # ---- Vensim -------------------------------------------------------------
    compared = ''
    if mdl_dir:
        say('\nRunning the Vensim originals and comparing the values at the end of each run\n')
        cmp = subprocess.run([sys.executable, os.path.join(REPO, 'tools/vensim/compare.py'), app_out, mdl_dir],
                             capture_output=True, text=True)
        compared = cmp.stdout + cmp.stderr
        say(compared.rstrip())
        say('\nAGREE = the same values as Vensim; DIFFER = some not the same (it shows which);')
        say('SKIPPED = not compared (a random model, a failed run, or no .mdl of that name).')

    with open(REPORT, 'w') as r:
        r.write('Checked %d models, %s\n' % (len(files), time.strftime('%Y-%m-%d %H:%M')))
        r.write('%d passed%s\n\n' % (len(passed), '; problems in ' + ', '.join(failed) if failed else ''))
        if changed_text:
            r.write('== Changed since recorded\n' + '\n'.join(changed_text) + '\n\n')
        if compared:
            r.write('== Compared with Vensim (%s)\n%s\n' % (mdl_dir, compared))
        r.write('== What the app found, model by model, and the values at the end of each run\n')
        r.write(open(app_out).read())
    say('\nThe full report: %s' % REPORT)
    sys.exit(1 if failed or missing or changed_text else 0)
except KeyboardInterrupt:
    say('\nStopped.')
finally:
    for proc in started:
        proc.terminate()
    shutil.rmtree(work, ignore_errors=True)
