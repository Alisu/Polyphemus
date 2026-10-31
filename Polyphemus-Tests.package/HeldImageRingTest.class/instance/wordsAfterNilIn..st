helpers
wordsAfterNilIn: aPid

	"nil's header and the three words after it: where a count written for an unregistered slot lands."

	| reader |
	reader := PolyphemusMadeFor current processMemoryClass on: aPid.
	^ [ reader whileStopped: [ | nil0 memory |
		    memory := SpurWritableProcess on: reader.
		    nil0 := (VMVariables on: reader) at: 'nilObj'.
		    (0 to: 3) collect: [ :each | memory wordAt: nil0 + (each * 8) ] ] ]
		  ensure: [ reader close ]
