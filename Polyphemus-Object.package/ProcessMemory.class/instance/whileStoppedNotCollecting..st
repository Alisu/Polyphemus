holding it still
whileStoppedNotCollecting: aBlock

	"aBlock's value, stopped at a moment no collection moves or marks objects, within five tries;
	else refused. Only the collector's state is read: lighter than whileStoppedOutsideACollection:."

	| why answer |
	5 timesRepeat: [
		answer := self whileStopped: [
			          why := self class whyCollectingIn: (VMVariables on: self).
			          why ifNil: [ { aBlock value } ] ].
		answer ifNotNil: [ ^ answer first ].
		(Delay forMilliseconds: 20) wait ].
	^ SpurCannotRead new
		  level: #bytes reason: #itWasNeverStoppedAtASafeMoment;
		  detail: 'last try: ' , why;
		  signal
