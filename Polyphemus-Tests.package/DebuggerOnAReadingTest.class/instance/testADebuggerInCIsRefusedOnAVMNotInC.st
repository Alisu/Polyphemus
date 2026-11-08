tests
testADebuggerInCIsRefusedOnAVMNotInC

	"#18: on a VM waiting for events or running Smalltalk, there is no C call to open on; the refusal
	says where its VM is instead."

	| pid |
	pid := self launchObservableTarget.
	[
	self
		should: [ Polyphemus debugInC: pid ]
		raise: Error
		withExceptionDo: [ :e | self assert: (e messageText beginsWith: 'not in a C call: ') ] ] ensure: [
		LibC system: 'kill ' , pid printString ]
