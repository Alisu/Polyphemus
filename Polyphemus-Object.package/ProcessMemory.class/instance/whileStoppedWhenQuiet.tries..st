holding it still
whileStoppedWhenQuiet: aBlock tries: aNumber

	"As #whileStoppedWhenQuiet:, given up after aNumber stops, 50 ms apart, that found it busy."

	| tries answer |
	tries := 0.
	[ self stop ifFalse: [ ^ self wouldNotStop ]. self isQuiet ] whileFalse: [
		self resume.
		(tries := tries + 1) > aNumber ifTrue: [
			^ (SpurCannotRead new level: #bytes reason: #itWasNeverQuietWhenStopped) signal ].
		(Delay forMilliseconds: 50) wait ].
	answer := aBlock valueThenLetGo: [ self resume ].
	self lastStopLasted ifFalse: [ ^ self ranWhileRead ].
	^ answer
