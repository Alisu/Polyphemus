running
assertEveryQuestionIsAnsweredOrRefusedByNameWithTheFrameDamagedAt: anIndex inWords: someNames

	"Each of those words of that frame (all of them for nil) holding each kind of damage in turn:
	what is shown answers, what is asked of the frame answers or is refused by a PolyphemusError,
	and all of it in good time."

	| frame framePointer unnamed |
	frame := self frames at: anIndex.
	framePointer := frame framePointer.
	unnamed := OrderedCollection new.
	((self wordsOf: framePointer) select: [ :each | someNames isNil or: [ someNames includes: each key ] ]) do: [ :word |
		(self kindsOfDamageAt: framePointer) do: [ :kind |
			| damage |
			damage := word key , ' holding ' , kind key.
			self while: word value holds: kind value do: [
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
					valueWithin: 30 seconds
					onTimeout: [ unnamed add: damage , ': not answered in thirty seconds' ] ] ] ].
	self assert: unnamed isEmpty description: (String cr join: unnamed)
