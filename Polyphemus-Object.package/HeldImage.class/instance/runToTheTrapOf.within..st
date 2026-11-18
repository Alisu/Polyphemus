holding
runToTheTrapOf: aMethodSource within: aDuration

	"With the trap armed: let the image go, and hold it where the trap fires, or where it got to
	once the time has passed, the trap taken out. Answers whether the method was reached."

	process letGo.
	(self waitFor: 'trap' within: aDuration) ifFalse: [
		(self holdWithin: 1 minute unless: [ (directory / 'trap') exists ]) ifTrue: [
			(self takeOutTheTrapRunningUntil: aMethodSource) ifNotNil: [ :reached | ^ reached ] ] ].
	(self waitFor: 'interrupted' within: 1 minute) ifFalse: [
		^ HoldFailed signal: 'the trap fired and the watcher never held the image' ].
	self serveAndHold: self trapsProcessHash startingAt: aMethodSource.
	^ true
