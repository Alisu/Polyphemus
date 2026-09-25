private
waitFor: aName within: aDuration

	"Whether the watcher or the trap left that file in time, checked every fifty milliseconds."

	| deadline |
	deadline := DateAndTime now + aDuration.
	[ (directory / aName) exists ] whileFalse: [
		DateAndTime now > deadline ifTrue: [ ^ false ].
		(Delay forMilliseconds: 50) wait ].
	^ true
