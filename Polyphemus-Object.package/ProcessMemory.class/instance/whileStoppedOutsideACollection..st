holding it still
whileStoppedOutsideACollection: aBlock

	"aBlock's value, stopped at a moment no collection runs and its classes and special objects
	read whole, within five tries; else refused, saying what the last try saw (#91, #113)."

	| tried |
	5 timesRepeat: [
		tried := self
			         whileStoppedIf: [ :fresh |
				         | phase |
				         phase := (VMVariables on: fresh) at: 'gcPhaseInProgress'.
				         phase = 0 ifFalse: [ 'collecting garbage (gcPhaseInProgress ' , phase printString , ')' ] ]
			         do: aBlock.
		tried isArray ifTrue: [ ^ tried first ] ].
	^ SpurCannotRead new
		  level: #bytes reason: #itWasNeverStoppedAtASafeMoment;
		  detail: 'last try: ' , tried;
		  signal
