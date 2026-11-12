holding it still
whileStoppedOutsideACollection: aBlock

	"aBlock's value, stopped at a moment no collection runs and its classes and special objects
	read whole, looked for until #safeMomentWait has passed; else refused, saying how often it
	looked and what the last stop saw (#91, #113, #31)."

	| tried stops deadline |
	stops := 0.
	deadline := DateAndTime now + self safeMomentWait.
	[
	stops := stops + 1.
	tried := self
		         whileStoppedIf: [ :fresh |
			         | phase |
			         phase := (VMVariables on: fresh) at: 'gcPhaseInProgress'.
			         phase = 0 ifFalse: [ 'collecting garbage (gcPhaseInProgress ' , phase printString , ')' ] ]
		         do: aBlock.
	tried isArray ifTrue: [ ^ tried first ].
	DateAndTime now > deadline ] whileFalse.
	^ SpurCannotRead new
		  level: #bytes reason: #itWasNeverStoppedAtASafeMoment;
		  detail: 'in ' , stops printString , ' stops, the last: ' , tried;
		  signal
