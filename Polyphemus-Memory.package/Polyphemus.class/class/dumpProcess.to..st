reading
dumpProcess: aPid to: aPath

	"A core file of a running VM, written while it is held still at a safe moment (#66, #113), so
	that readCoreDump: reads it back as it was. Refused as readProcess: refuses."

	| reader |
	reader := PolyphemusMadeFor current processMemoryClass on: aPid.
	^ [ reader whileStoppedToRead: [ :stopped | stopped writeDumpTo: aPath asFileReference ] ]
		  ensure: [ reader close ]
