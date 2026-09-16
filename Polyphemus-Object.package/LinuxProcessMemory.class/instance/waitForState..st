holding it still
waitForState: aLetter

	"Signals are delivered when the kernel gets round to it, not when the call returns."

	| waited |
	waited := 0.
	[ self state ~= aLetter and: [ waited < 100 ] ] whileTrue: [
		waited := waited + 1.
		(Delay forMilliseconds: 20) wait ].
	^ self state = aLetter
