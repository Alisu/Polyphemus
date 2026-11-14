accessing
oopClass

	"The class the image gives this value, found by its tag as the machine finds it (#42). Zero,
	or a word tagged as no immediate is, which only damage leaves where an object should be, is
	refused by name."

	| class |
	address = 0 ifTrue: [ ^ NotInTheReading signal: 'the word 0 is no object' ].
	class := memory reifyOop: (memory fetchClassOf: address).
	class isClassOop ifFalse: [
		^ NotInTheReading signal: 'the word ' , (address printStringRadix: 16) , ' is tagged as no immediate of this image is' ].
	^ class
