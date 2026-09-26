private
ringBefore: aDeadline

	"Ring once the agent says it is serving: a ring before would be lost (#49). Not serving by
	the deadline, it is not rung, and whoever waits for an answer finds none."

	bell ifNil: [ ^ self ].
	[ (directory / 'serving') exists ] whileFalse: [
		DateAndTime now > aDeadline ifTrue: [ ^ self ].
		(Delay forMilliseconds: 10) wait ].
	bell value
