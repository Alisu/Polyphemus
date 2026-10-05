helpers
selectorSentJustBefore: aFrame in: aMemory

	"The selector of the send whose instruction ends where aFrame's pc is, or nil (as in
	StackOfADumpTest)."

	| sends offset |
	sends := SendSequence new setCode: aFrame compiledCode; yourself.
	offset := aFrame pc - (aMemory firstBytecodePCOf: aFrame compiledCode).
	sends sendPCs doWithIndex: [ :each :index |
		(sends endOfInstructionAt: each) = offset ifTrue: [ ^ sends selectors at: index ] ].
	^ nil
