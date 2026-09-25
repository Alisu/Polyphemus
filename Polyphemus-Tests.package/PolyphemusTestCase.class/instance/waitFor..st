helpers
waitFor: aBlock

	"Whether it came true within a minute. A busy machine is slow, so what is waited for is
	the thing itself and never a number of seconds."

	| waited |
	waited := 0.
	[ aBlock value ] whileFalse: [
		(waited := waited + 1) > 600 ifTrue: [ ^ false ].
		(Delay forMilliseconds: 100) wait ].
	^ true
