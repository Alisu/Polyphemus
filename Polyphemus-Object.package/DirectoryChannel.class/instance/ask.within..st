asking
ask: aSource within: aDuration

	"What the image answers for that source: the print string of its value there. Written only
	once the agent says it serves, in the directory it made (#90)."

	| answer deadline text |
	deadline := DateAndTime now + aDuration.
	self hasExpired ifTrue: [ ^ PolyphemusChannelError signal: self whyExpired ].
	(self isServingBefore: deadline) ifFalse: [
		^ PolyphemusChannelError signal:
			  'the image did not answer within ' , aDuration printString , ': nothing was serving in '
			  , directory fullName , self whyNotServing ].
	count := count + 1.
	self write: aSource as: 'request.' , count printString.
	self ring.
	answer := directory / ('answer.' , count printString).
	[ answer exists ] whileFalse: [
		self hasExpired ifTrue: [ ^ PolyphemusChannelError signal: self whyExpired ].
		DateAndTime now > deadline ifTrue: [
			^ PolyphemusChannelError signal: 'the image did not answer within ' , aDuration printString ].
		(Delay forMilliseconds: 10) wait ].
	text := answer contents.
	(text beginsWith: 'ok' , String lf) ifTrue: [ ^ text allButFirst: 3 ].
	^ PolyphemusChannelError signal: (text copyAfter: Character lf)
