asking
ask: aSource

	(aSource includesSubstring: failing) ifTrue: [
		^ failure ifNil: [ self error: 'the agent is gone' ] ifNotNil: [ failure copy signal ] ].
	^ nil
