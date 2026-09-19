translating
indexOfSendAt: aPC

	"The send whose instruction contains aPC, else the first send after it, else nil."

	sends doWithIndex: [ :each :index |
		(aPC >= each key and: [ aPC < (self endOfInstructionAt: each key) ]) ifTrue: [
			^ index ] ].
	sends doWithIndex: [ :each :index | each key > aPC ifTrue: [ ^ index ] ].
	^ nil
