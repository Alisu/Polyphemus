asking
ask: aSource within: aDuration

	"What the image answers for that source: the print string of its value there. Written only
	once the agent says it serves, in the directory it made (#90); said at once if it is gone (#127)."

	| answer deadline text checked |
	deadline := DateAndTime now + aDuration.
	self hasExpired ifTrue: [ ^ PolyphemusChannelError signal: self whyExpired ].
	self whyGone ifNotNil: [ :why | ^ HeldImageGone signal: 'the image is gone: ' , why ].
	(self isServingBefore: deadline) ifFalse: [
		^ PolyphemusChannelError signal:
			  'the image did not answer within ' , aDuration printString , ': nothing was serving in '
			  , directory fullName , self whyNotServing ].
	count := count + 1.
	self write: aSource as: 'request.' , count printString.
	self ring.
	answer := directory / ('answer.' , count printString).
	checked := Time millisecondClockValue.
	[ answer exists ] whileFalse: [
		self hasExpired ifTrue: [ ^ PolyphemusChannelError signal: self whyExpired ].
		DateAndTime now > deadline ifTrue: [
			^ PolyphemusChannelError signal: 'the image did not answer within ' , aDuration printString ].
		Time millisecondClockValue - checked > 500 ifTrue: [
			checked := Time millisecondClockValue.
			self whyGone ifNotNil: [ :why | ^ HeldImageGone signal: 'the image is gone: ' , why ] ].
		(Delay forMilliseconds: 10) wait ].
	text := answer contents.
	(text beginsWith: 'ok' , String lf) ifTrue: [ ^ text allButFirst: 3 ].
	^ PolyphemusChannelError signal: (text copyAfter: Character lf)
