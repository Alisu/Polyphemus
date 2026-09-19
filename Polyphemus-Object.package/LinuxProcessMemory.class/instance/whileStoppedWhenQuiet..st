reading
whileStoppedWhenQuiet: aBlock

	"As #whileStopped:, stopped at a moment its VM is quiet (#isQuiet): a heap read half way
	through a garbage collection or an allocation reads as damage that is not there. Retried
	for about five seconds, then refused."

	| tries |
	tries := 0.
	[ self stop. self isQuiet ] whileFalse: [
		self resume.
		(tries := tries + 1) > 100 ifTrue: [
			^ (SpurCannotRead new level: #bytes reason: #itWasNeverQuietWhenStopped) signal ].
		(Delay forMilliseconds: 50) wait ].
	^ aBlock ensure: [ self resume ]
