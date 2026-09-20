writing
contextFor: aFrame sender: aSenderOop

	"The frame as a context: its own when it is married to one, a new one otherwise. Slots as
	StackInterpreter class>>initializeFrameIndices describes them: sender, pc, stackp, method,
	closure, receiver, then the arguments and the stack."

	| numArgs words stackp context memory |
	memory := dumped memory.
	numArgs := aFrame oopFlag numArgs.
	words := ((0 to: numArgs - 1) collect: [ :each |
		          self reified vmLayout temporary: each in: aFrame framePointer ])
		         , aFrame stackWords.
	stackp := words size.
	aFrame pc ifNil: [
		^ self error: 'the frame at ' , aFrame framePointer printStringHex , ' has no pc' ].
	context := self contextOf: aFrame holding: stackp.
	memory
		storePointer: 0 ofObject: context withValue: aSenderOop;
		storePointer: 1 ofObject: context withValue: (memory integerObjectOf: aFrame pc);
		storePointer: 2 ofObject: context withValue: (memory integerObjectOf: stackp);
		storePointer: 3 ofObject: context withValue: aFrame compiledCode address;
		storePointer: 4
		ofObject: context
		withValue: (aFrame closureOrNil ifNil: [ memory nilObject ] ifNotNil: [ :closure | closure address ]);
		storePointer: 5 ofObject: context withValue: aFrame oopReceiver address.
	1 to: (memory numSlotsOf: context) - 6 do: [ :each |
		memory
			storePointer: each + 5
			ofObject: context
			withValue: (each <= stackp
					 ifTrue: [ words at: each ]
					 ifFalse: [ memory nilObject ]) ].
	^ context
