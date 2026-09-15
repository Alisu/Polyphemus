naming
analysedNodeOf: anActivation

	"The method an activation is running, parsed and analysed against the class it came
	from, so that the names in it mean what they meant over there.

	Only the front half of the compiler is used: parsing and semantic analysis. Code is
	deliberately not generated here -- #hostMethodFor: does that, and checks it.

	Semantic warnings are off, which is the compiler's own switch for analysing code that is
	not this image's. Left on, a name the other image has and we cannot find is written into
	OUR Undeclared dictionary, and every temporary is reported as shadowing the undeclared
	name just invented for it.

	The source has to be the real source. A method whose source is gone decompiles to text
	whose temporaries are called tmp1 and arg1, and those are inventions of this image.

	Kept by the method and the class it was analysed against, not by the activation asking:
	every frame of a method shares the answer, and a page rebuilds its frames each time."

	| home receiverClass |
	home := [ anActivation homeMethod ] on: Error do: [ :e | nil ].
	receiverClass := [ anActivation receiver oopClass ] on: Error do: [ :e | nil ].
	(home isNil or: [ receiverClass isNil ]) ifTrue: [ ^ nil ].

	^ (self
		   rememberedAt: 'analysed.' , home address printString , '.'
			   , receiverClass address printString
		   ifAbsentPut: [
			   (self analyseMethodOf: home against: receiverClass) ifNil: [ false ] ])
		  ifNotNil: [ :cached | cached == false ifTrue: [ nil ] ifFalse: [ cached ] ]
