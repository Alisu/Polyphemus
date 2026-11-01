helpers
within: aDuration comesTrue: aBlock

	| deadline |
	deadline := DateAndTime now + aDuration.
	[ aBlock value ] whileFalse: [
		DateAndTime now > deadline ifTrue: [ ^ false ].
		(Delay forMilliseconds: 50) wait ].
	^ true
