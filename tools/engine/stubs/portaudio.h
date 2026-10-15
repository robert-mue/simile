/* Stand-in for PortAudio in a WebAssembly build: no sound device, ever. */
#ifndef PORTAUDIO_STUB_H
#define PORTAUDIO_STUB_H
typedef int PaError;
typedef void PaStream;
typedef unsigned long PaStreamCallbackFlags;
typedef unsigned long PaSampleFormat;
typedef struct { double inputBufferAdcTime, currentTime, outputBufferDacTime; } PaStreamCallbackTimeInfo;
typedef struct { int device; int channelCount; PaSampleFormat sampleFormat;
                 double suggestedLatency; void* hostApiSpecificStreamInfo; } PaStreamParameters;
typedef struct { int hostApiType; long errorCode; const char* errorText; } PaHostErrorInfo;
typedef int PaStreamCallback(const void*, void*, unsigned long,
                             const PaStreamCallbackTimeInfo*, PaStreamCallbackFlags, void*);
enum { paNoError = 0, paNotInitialized = -10000, paUnanticipatedHostError = -9999 };
enum { paContinue = 0 };
#define paFloat32 ((PaSampleFormat)1)
static inline PaError Pa_Initialize(void) { return paNotInitialized; }
static inline PaError Pa_Terminate(void) { return paNoError; }
static inline int Pa_GetDefaultOutputDevice(void) { return -1; }
static inline const char* Pa_GetErrorText(PaError) { return "no audio in this build"; }
static inline const PaHostErrorInfo* Pa_GetLastHostErrorInfo(void) { static PaHostErrorInfo i = {0,0,"none"}; return &i; }
static inline PaError Pa_OpenStream(PaStream**, const PaStreamParameters*, const PaStreamParameters*,
    double, unsigned long, PaStreamCallbackFlags, PaStreamCallback*, void*) { return paNotInitialized; }
static inline PaError Pa_OpenDefaultStream(PaStream**, int, int, PaSampleFormat, double, unsigned long,
    PaStreamCallback*, void*) { return paNotInitialized; }
static inline PaError Pa_StartStream(PaStream*) { return paNotInitialized; }
static inline PaError Pa_StopStream(PaStream*) { return paNoError; }
static inline PaError Pa_CloseStream(PaStream*) { return paNoError; }
static inline PaError Pa_WriteStream(PaStream*, const void*, unsigned long) { return paNotInitialized; }
#endif
