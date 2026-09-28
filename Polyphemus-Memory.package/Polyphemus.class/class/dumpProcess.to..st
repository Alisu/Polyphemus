reading
dumpProcess: aPid to: aPath

	"A core file of a running VM, written while it is held still at a quiet moment, so that
	readCoreDump: reads it back as it was (#66). Refused as readProcess: refuses."

	| reader |
	reader := LinuxProcessMemory on: aPid.
	^ [ reader whileStoppedWhenQuiet: [ reader writeDumpTo: aPath asFileReference ] ]
		  ensure: [ reader close ]
