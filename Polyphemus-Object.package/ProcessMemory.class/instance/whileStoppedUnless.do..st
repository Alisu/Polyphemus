holding it still
whileStoppedUnless: aWhyBlock do: aBlock

	"aBlock's value, stopped at a moment aWhyBlock, given the VM's variables, answers nil for,
	within five tries; else refused, saying what the last try saw."

	| why answer |
	5 timesRepeat: [
		answer := self whileStopped: [
			          why := aWhyBlock value: (VMVariables on: self).
			          why ifNil: [ { aBlock value } ] ].
		answer ifNotNil: [ ^ answer first ].
		(Delay forMilliseconds: 20) wait ].
	^ SpurCannotRead new
		  level: #bytes reason: #itWasNeverStoppedAtASafeMoment;
		  detail: 'last try: ' , why;
		  signal
