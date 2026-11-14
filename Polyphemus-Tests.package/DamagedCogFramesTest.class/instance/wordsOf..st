running
wordsOf: aFramePointer

	"The words around a frame pointer, each named by where it is: an interpreted frame and a
	machine code one keep different things in them, and between them they are all of a frame."

	^ #( 8 0 -8 -16 -24 -32 -40 ) collect: [ :each |
		  ('word ' , (each >= 0 ifTrue: [ '+' ] ifFalse: [ '' ]) , each printString) -> (aFramePointer + each) ]
