guessing
guessesEndingAt: anEnd
	"Each class making objects of the slots up to anEnd, when each slot holds a reference."

	| numSlots guesses |
	numSlots := anEnd - address // memory bytesPerOop - 1.
	((1 to: numSlots) allSatisfy: [ :index | self isReference: (memory long64At: address + (index * memory bytesPerOop)) ])
		ifFalse: [ ^ #(  ) ].
	guesses := OrderedCollection new.
	self classesDo: [ :aClass :classIndex |
		(self pointerFormatOfClass: aClass slots: numSlots) ifNotNil: [ :format |
			guesses add: (AbnormalObjectGuess new
					 className: (OOPAbstractEntity instantiateObject: aClass on: memory) printString;
					 classIndex: classIndex;
					 numSlots: numSlots;
					 format: format;
					 evidence: {
							 (self evidenceOfEnd: anEnd).
							 ('its {1} slots each hold an object or an immediate' format: { numSlots }) };
					 yourself) ] ].
	^ guesses
