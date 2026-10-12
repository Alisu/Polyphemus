tests
testARunningImageIsOpenedAndItsProcessesRead

	"Copied while it is held still at a quiet moment, then let go: the same tools read it as a core."

	| pid server opened handle processes deepest frames |
	pid := self launchObservableTarget.
	[
	server := PolyphemusMCPServer new.
	opened := self call: 'open_process' with: (Dictionary new at: 'pid' put: pid; yourself) on: server.
	self deny: (opened at: 'isError').
	handle := (opened at: 'structuredContent') at: 'handle'.
	processes := ((self call: 'processes' with: (Dictionary new at: 'handle' put: handle; yourself) on: server)
		              at: 'structuredContent') at: 'processes'.
	self assert: processes notEmpty.
	deepest := processes detectMax: [ :each | each at: 'depth' ].
	frames := ((self call: 'stack' with: (Dictionary new at: 'handle' put: handle; at: 'process' put: (deepest at: 'process'); yourself) on: server)
		           at: 'structuredContent') at: 'frames'.
	self assert: frames notEmpty ] ensure: [ LibC system: 'kill ' , pid printString ]
