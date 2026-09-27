private
is: anOop named: aString in: aSimulator

	"Whether anOop is a byte object spelling aString: a symbol, here."

	(aSimulator isImmediate: anOop) ifTrue: [ ^ false ].
	(aSimulator isBytes: anOop) ifFalse: [ ^ false ].
	(aSimulator numBytesOf: anOop) = aString size ifFalse: [ ^ false ].
	^ (1 to: aString size) allSatisfy: [ :each |
		  (aSimulator fetchByte: each - 1 ofObject: anOop) = (aString at: each) asInteger ]
