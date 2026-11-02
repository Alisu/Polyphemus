tests
testARunningVirtualMachineIsReadWithoutReifyingEveryObject

	"Read, a running VM is reified as it is looked at, not every object first: 210 s for a counter
	with 8 million strings more (#129). Asked of every object, the reading reifies the rest."

	| pid memory partial |
	pid := self launchObservableTarget.
	[
	memory := Polyphemus readProcess: pid.
	partial := (memory instVarNamed: #objects) size.
	self assert: partial * 10 < (memory select: [ :each | true ]) size ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
