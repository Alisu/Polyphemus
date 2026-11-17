tests
testASystemProcessIsRefusedEvenToRoot

	"With System Integrity Protection on, macOS gives no one the task port of its own binaries,
	such as /bin/sleep (measured as root, 2026-10-13); off, as on CI's runners, it is read and
	refused as no Pharo VM. Refused either way, saying which."

	| pid protected |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'measured as root: without root every other process is refused' ].
	protected := (LibC system: 'csrutil status | grep -q "status: enabled"') = 0.
	pid := self launchSleeper.
	[
	self
		should: [ MacProcessMemory on: pid ]
		raise: CannotReadProcess
		withExceptionDo: [ :e |
			self assert: e reason equals: (protected
					 ifTrue: [ #theOperatingSystemRefused ]
					 ifFalse: [ #notAPharoVirtualMachine ]) ] ] ensure: [
		LibC system: 'kill ' , pid printString ]
