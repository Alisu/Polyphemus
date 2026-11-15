running
assertEveryQuestionIsAnsweredOrRefusedByNameWithSlotsDamaged: someIndexes

	"Each of those slots of the class holding each kind of damage in turn: what is shown answers,
	and what is asked answers or is refused by a PolyphemusError, in good time."

	| unnamed |
	unnamed := OrderedCollection new.
	someIndexes do: [ :index |
		self kindsOfDamage do: [ :kind |
			| damage |
			damage := 'slot ' , index printString , ' holding ' , kind key.
			self whileSlot: index holds: kind value do: [
				[
				self whatIsShown do: [ :question |
					[ question value value ]
						on: Error
						do: [ :error | unnamed add: (self saying: error of: question under: damage) ] ].
				self whatIsAsked do: [ :question |
					[ question value value ]
						on: Error
						do: [ :error |
							(error isKindOf: PolyphemusError) ifFalse: [
								unnamed add: (self saying: error of: question under: damage) ] ] ] ]
					valueWithin: 30 seconds
					onTimeout: [ unnamed add: damage , ': not answered in thirty seconds' ] ] ] ].
	self assert: unnamed isEmpty description: (String cr join: unnamed)
