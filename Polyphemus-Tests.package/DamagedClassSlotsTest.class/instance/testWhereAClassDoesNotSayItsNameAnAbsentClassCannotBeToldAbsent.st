tests
testWhereAClassDoesNotSayItsNameAnAbsentClassCannotBeToldAbsent

	"#118: the name of one class overwritten. A class by a name no class says may be that one:
	refused saying so, not as a class the image does not have."

	self whileSlot: subject slotIndexForClassName holds: 16r29 do: [
		self
			should: [ reifiedMemory oopClassNamed: 'NoSuchClassInAnyImage' ]
			raise: NotInTheReading
			withExceptionDo: [ :refusal | self assert: (refusal messageText includesSubstring: 'cannot be told') ] ]
