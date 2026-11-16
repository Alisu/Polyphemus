tests
testNoCellOfTheMatrixStopsAReadingWithAnErrorThatIsNotOurs
	<readsAnUnsoundHeap>

	"#207: each damaged copy reads or is refused by name. 65 of the 590 failed with an error of
	VMMaker's before its loader, its walk and two special objects were named."

	| unnamed |
	unnamed := OrderedCollection new.
	self cellsOfTheMatrix do: [ :cell |
		self withACopyDamagedBy: (self addressOf: cell first at: cell second) -> (self wordOfKind: cell third) do: [ :copy |
			[
			[ Polyphemus readImageFile: copy fullName ]
				on: PolyphemusError
				do: [ :refusal | nil ] ]
				on: Error
				do: [ :error | unnamed add: cell printString , ' ' , error class name , ' ' , error messageText asString ] ] ].
	self assert: unnamed isEmpty description: (', ' join: unnamed)
