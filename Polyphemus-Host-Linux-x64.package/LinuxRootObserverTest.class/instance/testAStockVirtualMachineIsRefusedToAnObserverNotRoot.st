tests
testAStockVirtualMachineIsRefusedToAnObserverNotRoot

	"Yama, at ptrace_scope 1 or more, lets only an ancestor read a process: a VM someone else
	started is refused, the system named as what refused it."

	| pid |
	self isRoot ifTrue: [ ^ self skip: 'measured without root: root may read any process' ].
	self ptraceScope = 0 ifTrue: [ ^ self skip: 'ptrace_scope is 0 here: any process of ours can be read' ].
	pid := self launchStockTargetRunning: 'nil'.
	[
	self
		should: [ LinuxProcessMemory on: pid ]
		raise: CannotReadProcess
		withExceptionDo: [ :e | self assert: e reason equals: #theOperatingSystemRefused ] ] ensure: [
		LibC system: 'kill ' , pid printString ]
