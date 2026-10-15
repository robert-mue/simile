# Spike only: if SIMILE_EXPORT_IN/OUT are set, open that model, write its
# C++ source to OUT (menu code build_c, as Scripting.tcl's ExportCppCode
# did), copy everything in the build directory, and exit.
if {[info exists ::env(SIMILE_EXPORT_IN)]} {
    proc ::SpikeExport {} {
        set log [open $::env(SIMILE_EXPORT_OUT).log w]
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
        after 500 exit
    }
    after 4000 ::SpikeExport
}
