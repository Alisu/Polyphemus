reading
dumpProcess: aPid to: aPath

	"A core file of a running VM, written while it is held still at a safe moment (#66, #113), so
	that readCoreDump: reads it back as it was. Refused as readProcess: refuses."

	^ PolyphemusMadeFor current processMemoryClass writeDumpOf: aPid to: aPath