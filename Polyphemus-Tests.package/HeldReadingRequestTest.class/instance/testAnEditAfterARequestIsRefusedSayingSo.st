tests
testAnEditAfterARequestIsRefusedSayingSo

	| reading object held |
	reading := Object new.
	object := OOPObjectWithASlotThatDoesNotRead new.
	object memory: reading.
	held := HeldReading new.
	held instVarNamed: 'reading' put: reading.
	held noteARequest.
	self
		should: [ held whileStillWhereRead: object do: [ :memory | self fail: 'written' ] ]
		raise: StaleReading
		withExceptionDo: [ :error | self assert: (error messageText includesSubstring: 'request') ]
