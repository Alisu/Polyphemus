helpers
waitUntil: aBlock

	"Whether it came true within a minute. A busy machine loads an image slowly, so what is
	waited for is the thing itself, never a number of seconds."

	| waited |
	waited := 0.
	[ aBlock value ] whileFalse: [
		(waited := waited + 1) > 600 ifTrue: [ ^ false ].
		(Delay forMilliseconds: 100) wait ].
	^ true
