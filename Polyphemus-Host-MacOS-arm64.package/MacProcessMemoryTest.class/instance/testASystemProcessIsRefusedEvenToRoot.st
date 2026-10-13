tests
testASystemProcessIsRefusedEvenToRoot

	"macOS gives no one the task port of its own binaries, such as /bin/sleep: measured as root,
	2026-10-13. Said as the system's refusal, before asking whether it is Pharo."

	| pid |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'measured as root: without root every other process is refused' ].
	pid := self launchSleeper.
	[
	self
		should: [ MacProcessMemory on: pid ]
		raise: CannotReadProcess
		withExceptionDo: [ :e | self assert: e reason equals: #theOperatingSystemRefused ] ] ensure: [
		LibC system: 'kill ' , pid printString ]
