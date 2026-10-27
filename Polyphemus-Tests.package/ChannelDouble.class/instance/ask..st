asking
ask: aSource

	(aSource includesSubstring: failing) ifTrue: [ ^ self error: 'the agent is gone' ].
	^ nil
