private
waitFor: aBlock within: aDuration

	"Whether it came true in time, checked every fifty milliseconds."

	| deadline |
	deadline := DateAndTime now + aDuration.
	[ aBlock value ] whileFalse: [
		DateAndTime now > deadline ifTrue: [ ^ false ].
		(Delay forMilliseconds: 50) wait ].
	^ true
