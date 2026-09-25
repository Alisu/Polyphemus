holding
runUntil: aMethodSource within: aDuration

	"Let the image run until some process reaches that method, and hold it there, its debugger
	at the method's own context. Answers whether it was; if not, it is held where it got to."

	self forget: #( 'trap' 'interrupted' 'released' ).
	process ask: (PolyphemusAgent trapSourceFor: aMethodSource in: directory).
	process letGo.
	(self waitFor: 'trap' within: aDuration) ifFalse: [
		self holdWithin: 1 minute.
		process ask: PolyphemusAgent trapRemovalSource.
		^ false ].
	(self waitFor: 'interrupted' within: 1 minute) ifFalse: [
		^ self error: 'the trap fired and the watcher never held the image' ].
	self
		serveAndHold: (directory / 'trap') contents trimBoth asNumber
		startingAt: aMethodSource.
	^ true
