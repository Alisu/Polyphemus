private
isServingBefore: aDeadline

	"Whether the agent says it serves, by the deadline: a ring before would be lost (#49), and
	a request before would make its directory ours (#90). Not once the image is gone (#127)."

	| checked |
	checked := Time millisecondClockValue.
	[ (directory / 'serving') exists ] whileFalse: [
		DateAndTime now > aDeadline ifTrue: [ ^ false ].
		Time millisecondClockValue - checked > 500 ifTrue: [
			checked := Time millisecondClockValue.
			self whyGone ifNotNil: [ ^ false ] ].
		(Delay forMilliseconds: 10) wait ].
	^ true
