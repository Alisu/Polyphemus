looking
after: aCount lookUntil: aTryBlock once: aBoolean

	"aTryBlock's value once it answers one, in an Array, and not why not, a string: tried until
	the reader's safeMomentWait has passed, or once when aBoolean. Else refused, saying how often it
	looked, aCount stops before included, and what the last stop saw (#91, #31)."

	| tried stops deadline |
	stops := aCount.
	deadline := DateAndTime now + reader safeMomentWait.
	[
	stops := stops + 1.
	tried := aTryBlock value.
	tried isArray ifTrue: [ ^ tried first ].
	aBoolean or: [ DateAndTime now > deadline ] ] whileFalse.
	^ SpurCannotRead new
		  level: #bytes reason: #itWasNeverStoppedAtASafeMoment;
		  detail: 'in ' , stops printString , ' stops, the last: ' , tried;
		  signal
