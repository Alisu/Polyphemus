tests
testAWarningLetsGoBeforeItIsShown

	| letGo seenLetGo |
	letGo := false.
	[ [ Warning signal: 'careful' ] valueThenLetGo: [ letGo := true ] ]
		on: Warning
		do: [ :warning | seenLetGo := letGo ].
	self assert: seenLetGo
