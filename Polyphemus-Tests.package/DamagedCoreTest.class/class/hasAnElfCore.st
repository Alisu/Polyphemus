testing
hasAnElfCore

	"Whether this setup has a core, and one the damage is written for: ELF, as Linux writes."

	| file |
	file := SpurDumpedMemoryTest new dumpFile.
	^ file exists and: [ (file binaryReadStreamDo: [ :stream | stream next: 4 ]) = #[ 127 69 76 70 ] ]
