holding it still
whileStoppedUnless: aWhyBlock do: aBlock

	"aBlock's value, stopped at a moment aWhyBlock, given the VM's variables, answers nil for:
	looked for until #safeMomentWait has passed, once when its caller holds it stopped. Else
	refused, saying how often it looked and what the last stop saw (#31, #186)."

	| why answer stops deadline |
	stops := 0.
	deadline := DateAndTime now + self safeMomentWait.
	[
	stops := stops + 1.
	answer := self whileStopped: [
		          why := aWhyBlock value: (VMVariables on: self).
		          why ifNil: [ { aBlock value } ] ifNotNil: [ nil ] ].
	answer ifNotNil: [ ^ answer first ].
	self isStoppedHere or: [ DateAndTime now > deadline ] ] whileFalse: [ (Delay forMilliseconds: 20) wait ].
	^ SpurCannotRead new
		  level: #bytes reason: #itWasNeverStoppedAtASafeMoment;
		  detail: 'in ' , stops printString , ' stops, the last: ' , why;
		  signal
