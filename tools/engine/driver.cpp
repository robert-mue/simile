// Spike 2 driver, v2: run a compiled Simile model as a display would use it.
//   driver2 <model lib> <run length> <time step> <log every> <runs> <node:name>...
// Reads every named node at each log point (all members of a population),
// and counts the bytes those values occupy.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <vector>
#include <string>
#include <dllcalls.h>
#include <backend.h>
#include <6d.h>

static double now_ms() {
  timespec ts; clock_gettime(CLOCK_MONOTONIC, &ts);
  return ts.tv_sec*1e3 + ts.tv_nsec/1e6;
}

struct Watch { std::string id, name; double last; int members; };

// Total size in bytes of a nodeValues block, and its first double.
static long read_node(const char* id, void* inst, double* first, int* members) {
  nodeValues* v = get_raw_values((char*)id, inst);
  if (!v) return 0;
  long bytes = 0;
  *members = 1;
  int kind = v->dimSpecs[0];
  if (kind == UNSTABLE) { *members = -1; return 0; }
  if (v->contents) {
    if (kind == REAL) {                  // one number
      *first = *(double*)v->contents; bytes = sizeof(double);
    } else if (kind == SPARSEARRAY && v->dimSpecs[2] == REAL) {
      sizeAndPtr* sp = (sizeAndPtr*)v->contents;   // a population's members
      *members = sp->size;
      *first = sp->size > 0 ? ((double*)sp->ptr)[0] : 0;
      bytes = (long)sp->size*sizeof(double);
    } else {
      *members = -2;                     // a shape this spike does not read
    }
  }
  return bytes;                          // leaks v: spike only
}

int main(int argc, char** argv) {
  if (argc < 6) { printf("usage: driver2 lib runlength dt logeach runs [node:name]...\n"); return 2; }
  const char* lib = argv[1];
  double runLength = atof(argv[2]), dt = atof(argv[3]), logEach = atof(argv[4]);
  int runs = atoi(argv[5]);
  std::vector<Watch> w;
  for (int i = 6; i < argc; i++) {
    char* c = strchr(argv[i], ':');
    w.push_back({std::string(argv[i], c - argv[i]), std::string(c + 1), 0, 0});
  }
  void* type = NULL;
  char* problem = load_model((char*)lib, (char*)"free", &type);
  if (problem) { printf("load_model: %s\n", problem); return 1; }
  void* inst = fetch_top_instance(type, NULL);
  for (int st = 1; st < 8; st++) setstep(inst, dt, st);
  long bytes = 0;
  double t0 = now_ms(), first = 0;
  for (int r = 0; r < runs; r++) {
    bytes = 0;
    excpData* e = reset(type, inst, 0.0, 0, -2);
    if (e && e->excpNo) { printf("reset excp %d\n", e->excpNo); return 1; }
    int nLog = (int)(runLength/logEach + 0.5);
    for (int k = 1; k <= nLog; k++) {
      e = execute(type, inst, 0, (k-1)*logEach, k*logEach, 0.0, 0, 0);
      if (e && e->excpNo) { printf("exec excp %d at %g\n", e->excpNo, e->timeOfCrime); return 1; }
      // what the threaded path does when a step ends: populations readable
      ((ExecutingModel*)inst)->set_completion(2);
      for (auto& x : w) bytes += read_node(x.id.c_str(), inst, &x.last, &x.members);
    }
    if (r == 0) first = now_ms() - t0;
  }
  double el = now_ms() - t0;
  for (auto& x : w)
    printf("  %-14s %s  final %.10g%s\n", x.name.c_str(), x.id.c_str(), x.last,
           x.members == -1 ? " UNSTABLE" : x.members == -2 ? " (unread shape)" :
           x.members != 1 ? (" (first of " + std::to_string(x.members) + " members)").c_str() : "");
  printf("values read per run: %ld bytes\n", bytes);
  printf("%d run(s): first %.3f ms, mean %.4f ms per run\n", runs, first, el/runs);
  return 0;
}
