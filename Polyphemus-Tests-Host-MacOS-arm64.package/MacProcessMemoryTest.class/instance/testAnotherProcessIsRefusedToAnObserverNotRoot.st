tests
testAnotherProcessIsRefusedToAnObserverNotRoot

	"Without root, macOS gives no other process's task port: said as a refusal, not a failure."

	| pid |
	MacProcessMemory isRoot ifTrue: [ ^ self skip: 'run as root: this is what a non-root observer meets' ].
	pid := self launchSleeper.
	[
	self
		should: [ MacProcessMemory on: pid ]
		raise: CannotReadProcess
		withExceptionDo: [ :e | self assert: e reason equals: #theOperatingSystemRefused ] ] ensure: [
		LibC system: 'kill ' , pid printString ]
