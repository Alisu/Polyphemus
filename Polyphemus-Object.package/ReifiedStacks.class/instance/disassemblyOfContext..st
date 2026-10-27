contexts
disassemblyOfContext: aContextOop

	"The bytecodes a context runs, one per line, its block's own in a block: what a frame can always
	show when the source is missing, as in a bootstrap image or a script's code."

	^ String streamContents: [ :stream |
		  [ (aContextOop reifiedSlotAt: self contextMethodSlot) allSymbolicBytecodes do: [ :each |
			    stream
				    nextPutAll: each printString;
				    cr ] ]
			  on: Error
			  do: [ :e |
				  stream nextPutAll: 'bytecodes unreadable: '.
				  stream nextPutAll: e messageText asString ] ]
