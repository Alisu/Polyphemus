contexts
disassemblyOfContext: aContextOop

	"The bytecodes a context runs, one per line: what a frame can always show when the source is
	missing, as in a bootstrap image."

	^ String streamContents: [ :stream |
		  [ (self homeMethodOf: (aContextOop reifiedSlotAt: self contextMethodSlot))
			    allSymbolicBytecodes do: [ :each |
			    stream
				    nextPutAll: each printString;
				    cr ] ]
			  on: Error
			  do: [ :e |
				  stream nextPutAll: 'bytecodes unreadable: '.
				  stream nextPutAll: e messageText asString ] ]
