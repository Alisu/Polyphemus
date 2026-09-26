asking
ask: aSource within: aDuration

	"What the image answers for that source: the print string of its value there."

	| answer deadline text |
	count := count + 1.
	self write: aSource as: 'request.' , count printString.
	answer := directory / ('answer.' , count printString).
	deadline := DateAndTime now + aDuration.
	self ringBefore: deadline.
	[ answer exists ] whileFalse: [
		DateAndTime now > deadline ifTrue: [
			^ PolyphemusChannelError signal:
				  'the image did not answer within ' , aDuration printString ].
		(Delay forMilliseconds: 10) wait ].
	text := answer contents.
	(text beginsWith: 'ok' , String lf) ifTrue: [ ^ text allButFirst: 3 ].
	^ PolyphemusChannelError signal: (text copyAfter: Character lf)
