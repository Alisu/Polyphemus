reading
copyProcess: aPid

	"What a reading needs of a running VM, copied while it is held still at a quiet moment
	(#66, #85), to be read as a core is once it has run on, or ended. Refused as readProcess:."

	| reader |
	reader := PolyphemusMadeFor current processMemoryClass on: aPid.
	^ [ reader whileStoppedWhenQuiet: [ ProcessMemoryCopy of: reader ] ] ensure: [ reader close ]
