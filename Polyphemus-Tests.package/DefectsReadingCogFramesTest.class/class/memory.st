accessing
memory

	"The setup's core, read once for the class."

	^ Memory ifNil: [ Memory := Polyphemus readCoreDump: SpurDumpedMemoryTest new dumpFile fullName ]
