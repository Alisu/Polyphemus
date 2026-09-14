contexts
disassemblyOfContext: aContextOop

	"The bytecodes of the method a context is running, as text, one per line.

	Source can be missing: a bootstrap image ships no sources file, and a damaged one
	may have lost it. Bytecodes are in the image by definition, so a frame can always
	show something."

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
