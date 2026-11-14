running
assertEveryQuestionIsAnsweredOrRefusedByNameWithTheFrameDamagedAt: anIndex

	"Each word of that frame holding each kind of damage in turn: what is shown answers, what is
	asked of the frame answers or is refused by a PolyphemusError, and all of it in good time."

	| framePointer unnamed |
	framePointer := (self frames at: anIndex) framePointer.
	unnamed := OrderedCollection new.
	(self fieldsOf: framePointer) do: [ :field |
		(self kindsOfDamageAt: framePointer) do: [ :kind |
			| damage |
			damage := 'its ' , field key , ' holding ' , kind key.
			self while: field value holds: kind value do: [
				[
				(self whatIsShownOfFrame: anIndex) do: [ :question |
					[ question value value ]
						on: Error
						do: [ :error | unnamed add: (self saying: error of: question under: damage) ] ].
				(self whatIsAskedOfFrame: anIndex) do: [ :question |
					[ question value value ]
						on: Error
						do: [ :error |
							(error isKindOf: PolyphemusError) ifFalse: [
								unnamed add: (self saying: error of: question under: damage) ] ] ] ]
					valueWithin: 20 seconds
					onTimeout: [ unnamed add: damage , ': not answered in twenty seconds' ] ] ] ].
	self assert: unnamed isEmpty description: (String cr join: unnamed)
