# Spike only: if SIMILE_EXPORT_IN/OUT are set, open that model, write its
# C++ source to OUT (menu code build_c, as Scripting.tcl's ExportCppCode
# did), copy everything in the build directory, and exit.
# With SIMILE_PIPE_LOG set, every message between Tcl and Prolog from the
# model's opening on is written there (prolog.tcl's own debug log).
if {[info exists ::env(SIMILE_EXPORT_IN)]} {
    proc ::SpikeExport {} {
        set log [open $::env(SIMILE_EXPORT_OUT).log w]
        if {[info exists ::env(SIMILE_PIPE_LOG)]} {
            set ::plPipe(debug_stream) [open $::env(SIMILE_PIPE_LOG) w]
            fconfigure $::plPipe(debug_stream) -encoding utf-8 -buffering line
            set ::plPipe(debug) 1
        }
        if {[catch {
            similescript::ModelWindow create ::spikeWin
            ::spikeWin open $::env(SIMILE_EXPORT_IN)
            set ::preSelect $::env(SIMILE_EXPORT_OUT)
            MenuSelect [::spikeWin getModelCanvas] code build_c
            puts $log "simtmpdir: $::simtmpdir"
            foreach f [glob -nocomplain -directory $::simtmpdir -tails *] {
                puts $log "  $f"
            }
        } err]} {
            puts $log "ERROR: $err\n$::errorInfo"
        }
        close $log
        if {[info exists ::env(SIMILE_PIPE_LOG)]} {
            set ::plPipe(debug) 0
            close $::plPipe(debug_stream)
        }
        after 500 exit
    }
    after 4000 ::SpikeExport
}
