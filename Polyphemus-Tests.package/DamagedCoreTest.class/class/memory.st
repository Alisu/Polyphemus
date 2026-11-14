accessing
memory

	"The damaged copy read once for the class."

	^ Memory ifNil: [
		  Memory := Polyphemus readCoreDump: (self damagedCopyOf: SpurDumpedMemoryTest new dumpFile) fullName ]
