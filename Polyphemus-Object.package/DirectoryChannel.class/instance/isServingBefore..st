private
isServingBefore: aDeadline

	"Whether the agent says it serves, by the deadline: a ring before would be lost (#49), and
	a request before would make its directory ours (#90)."

	[ (directory / 'serving') exists ] whileFalse: [
		DateAndTime now > aDeadline ifTrue: [ ^ false ].
		(Delay forMilliseconds: 10) wait ].
	^ true
