tests
testARunningVirtualMachineIsOpenedAndItsProcessesRead

	"A stock VM, copied while held still at a quiet moment, then let go: the same tools read it
	as they read a core."

	| pid server opened handle processes deepest frames |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the server run as root (sudo)' ].
	pid := self launchIdleTarget.
	[
	server := PolyphemusMCPServer new.
	opened := PolyphemusMCPLiveToolsTest new call: 'open_process' with: (Dictionary new at: 'pid' put: pid; yourself) on: server.
	self deny: (opened at: 'isError').
	handle := (opened at: 'structuredContent') at: 'handle'.
	processes := ((PolyphemusMCPLiveToolsTest new call: 'processes' with: (Dictionary new at: 'handle' put: handle; yourself) on: server)
		              at: 'structuredContent') at: 'processes'.
	self assert: processes notEmpty.
	deepest := processes detectMax: [ :each | each at: 'depth' ].
	frames := ((PolyphemusMCPLiveToolsTest new
		            call: 'stack'
		            with: (Dictionary new at: 'handle' put: handle; at: 'process' put: (deepest at: 'process'); yourself)
		            on: server) at: 'structuredContent') at: 'frames'.
	self assert: frames notEmpty ] ensure: [ LibC system: 'kill ' , pid printString ]
