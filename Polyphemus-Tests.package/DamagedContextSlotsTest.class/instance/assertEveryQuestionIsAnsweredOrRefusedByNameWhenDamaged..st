running
assertEveryQuestionIsAnsweredOrRefusedByNameWhenDamaged: aSlotIndex

	"That slot of each context holding each kind of damage in turn: what is shown answers, and
	what is asked of the context answers or is refused by a PolyphemusError."

	| unnamed |
	unnamed := OrderedCollection new.
	contexts do: [ :context |
		self kindsOfDamage do: [ :kind |
			self whileSlot: aSlotIndex of: context holds: (kind value value: context) do: [
				(self whatIsShownOf: context) do: [ :question |
					[ question value value ]
						on: Error
						do: [ :error | unnamed add: (self saying: error of: question under: kind) ] ].
				(self whatIsAskedOf: context) do: [ :question |
					[ question value value ]
						on: Error
						do: [ :error |
							(error isKindOf: PolyphemusError) ifFalse: [
								unnamed add: (self saying: error of: question under: kind) ] ] ] ] ] ].
	self assert: unnamed isEmpty description: (String cr join: unnamed)
