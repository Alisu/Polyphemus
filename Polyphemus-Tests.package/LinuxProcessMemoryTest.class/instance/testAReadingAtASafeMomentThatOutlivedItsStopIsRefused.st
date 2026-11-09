tests
testAReadingAtASafeMomentThatOutlivedItsStopIsRefused

	"#113: as at a quiet moment (#137), a reading the stop's bound cut short is refused, the process
	having run under it."

	| pid reader |
	pid := self launchObservableTarget.
	reader := PolyphemusMadeFor current processMemoryClass on: pid.
	reader stopBound: 1 second.
	[
	self
		should: [ reader whileStoppedAtASafeMoment: [ (Delay forSeconds: 3) wait ] ]
		raise: SpurCannotRead
		withExceptionDo: [ :error | self assert: error reason equals: #itRanWhileRead ] ] ensure: [
		LibC system: 'kill -9 ' , pid printString.
		reader close ]
