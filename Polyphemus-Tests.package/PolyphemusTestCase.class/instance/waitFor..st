helpers
waitFor: aBlock

	"Whether it came true within three minutes. A busy machine is slow, so what is waited for
	is the thing itself; the bound only says when to give up (a hot box took over one, #31)."

	| waited |
	waited := 0.
	[ aBlock value ] whileFalse: [
		(waited := waited + 1) > 1800 ifTrue: [ ^ false ].
		(Delay forMilliseconds: 100) wait ].
	^ true
