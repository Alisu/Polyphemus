running
assertEveryQuestionIsAnsweredOrRefusedByNameWhenDamaged: aSlotIndex

	"That slot of each context holding each kind of damage in turn: no question fails with an
	error that is not a PolyphemusError."

	| unnamed |
	unnamed := OrderedCollection new.
	contexts do: [ :context |
		self kindsOfDamage do: [ :kind |
			self whileSlot: aSlotIndex of: context holds: (kind value value: context) do: [
				(self questionsOf: context) do: [ :question |
					[ question value value ]
						on: Error
						do: [ :error |
							(error isKindOf: PolyphemusError) ifFalse: [
								unnamed add: kind key , ', ' , question key , ': ' , error class name , ' '
									, (error messageText asString truncateTo: 80) ] ] ] ] ] ].
	self assert: unnamed isEmpty description: (String cr join: unnamed)
