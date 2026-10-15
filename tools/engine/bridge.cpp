// The Simile engine as JavaScript sees it: a few C calls over shank's API
// (dllcalls.h), answering in the shapes SimiLive's server sends
// (Extensions/www/web_embed.tcl, ResponseTo), so the session layer can talk
// to a model running in the page as it talks to one on SimiLive.
//
// One model per engine instance: each model brings its own copy of support2's
// globals, and two dlopened into one instance collide (README, step 2). The
// page makes a fresh instance per model instead, so the state here is global.
//
// Built into the run-time library's main module by build-runtime.sh.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <map>
#include <dllcalls.h>
#include <backend.h>
#include <6d.h>
#include <emscripten.h>

// Raised by setup_randoms: the next reset or run starts the random numbers
// from the seed. The threaded path lowers it when its first job is done
// (check_thread); these single-threaded calls must do the same, or every
// call starts the stream again and each one draws the same numbers.
extern BOOLEAN rand_inits_updated;

static void* modelType = NULL;
static void* instance = NULL;
static std::string reply;            // what the last call returns as text
static std::map<std::string, void*> params;   // node id -> parameter slot
static bool firstReset = true;

static const char* CLASSES[] = {"SUBMODEL", "VARIABLE", "COMPARTMENT", "FLOW",
  "CONDITION", "CREATION", "REPRODUCTION", "IMMIGRATION", "LOSS", "ITERATION",
  "EVENT", "SQUIRT", "STATE"};
static const char* EVALS[] = {"EXOGENOUS", "DERIVED", "TABLE", "INPUT", "GHOST",
  "LIMIT", "RECALL", "BLOCK", "POPULATION", "GRID", "HONEYCOMB"};

static const char* typeName(int t) {
  switch (t) {
  case VALUELESS: return "VALUELESS";
  case REAL: return "REAL";
  case INTEGER: return "INTEGER";
  case FLAG: return "FLAG";
  default: return t <= ENUM_BASE ? "INTEGER" : "EXTERNAL";
  }
}

static void addJsonString(std::string& out, const char* s) {
  out += '"';
  for (const char* p = s ? s : ""; *p; ++p) {
    switch (*p) {
    case '"': out += "\\\""; break;
    case '\\': out += "\\\\"; break;
    case '\n': out += "\\n"; break;
    case '\t': out += "\\t"; break;
    case '\r': break;
    default: out += *p;
    }
  }
  out += '"';
}

static void addNumber(std::string& out, double v) {
  char buf[32];
  if (v != v) { out += "null"; return; }              // NaN is not JSON
  snprintf(buf, sizeof buf, "%.17g", v);
  if (!strchr(buf, 'n') && !strchr(buf, 'i')) out += buf; else out += "null";
}

// Size in bytes of one value of a data type, as the engine packs it.
static int sizeOfType(int t) { return t == REAL ? sizeof(double) : sizeof(int); }

static double numberAt(const char* p, int t) {
  if (t == REAL) { double d; memcpy(&d, p, sizeof d); return d; }
  int i; memcpy(&i, p, sizeof i); return i;
}

extern "C" {

EMSCRIPTEN_KEEPALIVE
const char* sx_load(const char* file) {
  char* problem = load_model((char*)file, (char*)"free", &modelType);
  if (problem) { reply = problem; free(problem); return reply.c_str(); }
  instance = fetch_top_instance(modelType, NULL);
  if (!instance) { reply = "Failed to create model instance"; return reply.c_str(); }
  // An instance that is never given a step loops forever (client5d.tcl).
  for (int st = 1; st < 8; st++) setstep(instance, 0.1, st);
  firstReset = true;
  return "";
}

// The component dictionary, as Describe sends it.
EMSCRIPTEN_KEEPALIVE
const char* sx_describe() {
  int count = get_node_count(modelType);
  std::map<std::string, std::string> idOfPath;
  std::string out = "{";
  bool first = true;
  for (int line = 1; line < count; ++line) {
    node_data_line* nl = get_data_line(modelType, line);
    char caption[1024] = "";
    int dims[32] = {0};
    enum_type_data* types[32];
    if (!searchinfo((char*)nl->name, modelType, caption, dims, types)) continue;
    std::string path = caption[0] == '/' ? caption : std::string("/") + caption;
    idOfPath[path] = nl->name;
    std::string parentPath = path.substr(0, path.rfind('/'));
    std::string tail = path.substr(path.rfind('/') + 1);

    if (!first) out += ", ";
    first = false;
    addJsonString(out, nl->name);
    out += ": {\"parent\": ";
    addJsonString(out, parentPath.empty() ? "#"
                  : idOfPath.count(parentPath) ? idOfPath[parentPath].c_str() : "#");
    out += ", \"text\": "; addJsonString(out, tail.c_str());
    out += ", \"captpath\": "; addJsonString(out, path.c_str());
    int cls = nl->compclass;
    std::string icon = std::string("images/")
      + (cls >= 0 && cls <= STATE ? CLASSES[cls] : "VARIABLE") + ".gif";
    out += ", \"icon\": "; addJsonString(out, icon.c_str());
    out += ", \"equation\": "; addJsonString(out, nl->strings[1]);
    out += ", \"comment\": "; addJsonString(out, nl->strings[3]);
    out += ", \"eval\": ";
    addJsonString(out, nl->eval >= 0 && nl->eval <= HONEYCOMB ? EVALS[nl->eval] : "DERIVED");
    char num[32];
    snprintf(num, sizeof num, "%g", nl->min);
    out += ", \"min\": "; addJsonString(out, num);
    snprintf(num, sizeof num, "%g", nl->max);
    out += ", \"max\": "; addJsonString(out, num);
    out += ", \"type\": "; addJsonString(out, typeName(nl->datatype));
    out += ", \"units\": "; addJsonString(out, nl->strings[2]);
    // dims as SimiLive writes them: a count, MEMBERS or RECORDS per level,
    // then 0; and an (empty) list of enum names per entry
    out += ", \"dims\": [";
    int n = 0;
    for (;; ++n) {
      if (n) out += ", ";
      int d = dims[n];
      if (d == MEMBERS) out += "\"MEMBERS\"";
      else if (d == RECORDS) out += "\"RECORDS\"";
      else { snprintf(num, sizeof num, "%d", d > 0 ? d : 0); out += num; }
      if (d == 0 || n == 30) break;
    }
    out += "], \"trans\": [";
    for (int k = 0; k <= n; ++k) out += k ? ", []" : "[]";
    out += "]}";
  }
  out += "}";
  reply = out;
  return reply.c_str();
}

EMSCRIPTEN_KEEPALIVE
void sx_setstep(int phase, double dt) {
  setstep(instance, dt, phase);
}

// Back to the start. After the first reset, slider values are kept: the
// engine's "slider rollover" (how_int -1), under which a starting value takes
// a parameter's value too, so no rebuild is needed for one.
// A reset of depth -2 seeds the random numbers, as go_reset does (the
// single-threaded reset does not, and every run would draw the same).
EMSCRIPTEN_KEEPALIVE
int sx_reset(double t0, int depth, unsigned int seed) {
  excpData* e;
  if (firstReset || depth == -2) setup_randoms(seed);
  if (firstReset) {
    e = reset(modelType, instance, t0, 0, -2);
    if (!(e && e->excpNo) && !params.empty())
      e = reset(modelType, instance, t0, -1, 0);
    firstReset = false;
  } else {
    e = reset(modelType, instance, t0, -1, depth < 0 ? 0 : depth);
  }
  ((ExecutingModel*)instance)->set_completion(2);
  rand_inits_updated = FALSE;
  return e ? e->excpNo : 0;
}

// Advance from `from` to `to`. Returns the exception number (0 for none);
// sx_stopped_at() is then where it stopped.
static double stoppedAt = 0;

EMSCRIPTEN_KEEPALIVE
int sx_execute(double from, double to) {
  excpData* e = execute(modelType, instance, 0, from, to, 0.0, 0, 0);
  // what the threaded path does as a step ends: populations become readable
  ((ExecutingModel*)instance)->set_completion(2);
  rand_inits_updated = FALSE;
  stoppedAt = to;
  if (e && e->excpNo) { stoppedAt = e->timeOfCrime; return e->excpNo; }
  return 0;
}

EMSCRIPTEN_KEEPALIVE
double sx_stopped_at() { return stoppedAt; }

// One component's current value as JSON: a number, {member: value} for a
// population (keys are the members' own numbers, kept for their lives), or
// null for a shape not read here yet.
EMSCRIPTEN_KEEPALIVE
const char* sx_value(const char* nodeId) {
  nodeValues* v = get_raw_values((char*)nodeId, instance);
  reply = "null";
  if (!v) return reply.c_str();
  int kind = v->dimSpecs[0];
  if (v->contents) {
    if (kind == REAL || kind == INTEGER || kind == FLAG || kind <= ENUM_BASE) {
      reply.clear();
      addNumber(reply, numberAt(v->contents, kind));
    } else if (kind == SPARSEARRAY && v->dimSpecs[1] == 1) {
      int t = v->dimSpecs[2];
      if (t == REAL || t == INTEGER || t == FLAG || t <= ENUM_BASE) {
        sizeAndPtr* sp = (sizeAndPtr*)v->contents;
        int stride = sizeof(int) + sizeOfType(t);
        reply = "{";
        for (int i = 0; i < sp->size; ++i) {
          const char* at = sp->ptr + i * stride;
          int member; memcpy(&member, at, sizeof member);
          char key[24]; snprintf(key, sizeof key, "%s\"%d\": ", i ? ", " : "", member);
          reply += key;
          addNumber(reply, numberAt(at + sizeof(int), t));
        }
        reply += "}";
      }
    }
    free_bloc_data(v->contents, v->dimSpecs);
  }
  delete v;
  return reply.c_str();
}

// A slider's value for a parameter, taken from the next reset on.
EMSCRIPTEN_KEEPALIVE
int sx_param(const char* nodeId, double value) {
  void* h = params.count(nodeId) ? params[nodeId] : use_array_for_params(instance, (char*)nodeId);
  if (!h) return 0;
  params[nodeId] = h;
  int* dims;
  char* where = get_param_ptr_and_dims(h, &dims);
  if (!where || dims[0] != REAL) return 0;
  memcpy(where, &value, sizeof value);
  return 1;
}

// Back to the model's own value.
EMSCRIPTEN_KEEPALIVE
void sx_param_clear(const char* nodeId) {
  if (!params.count(nodeId)) return;
  forget_param_array(params[nodeId]);
  params.erase(nodeId);
}

EMSCRIPTEN_KEEPALIVE
void sx_exit() {
  if (modelType) myexit(modelType, instance);
  modelType = instance = NULL;
  params.clear();
}

}
