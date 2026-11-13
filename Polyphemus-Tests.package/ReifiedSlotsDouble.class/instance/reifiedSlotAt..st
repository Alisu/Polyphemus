accessing
reifiedSlotAt: anIndex

	"A slot it does not have is asked for by mistake: that fails the test, whatever handler is around."

	anIndex > slots size ifTrue: [
		^ TestFailure new signal: 'asked for slot ' , anIndex printString , ' of ' , slots size printString ].
	^ (slots at: anIndex) value
