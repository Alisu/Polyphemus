tests
testItsYoungObjectsAreReadWhereTheVirtualMachineLeftThem

	"Past space up to pastSpaceStart, eden up to freeStart, though this VM names no eden: its
	start is where the survivor spaces end (#82). Without it, new space was walked by shape."

	| pid reader ranges |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	pid := self launchIdleTarget.
	[
	reader := MacProcessMemory on: pid.
	reader whileStopped: [ ranges := (SpurDumpedMemory on: reader) raw liveYoungRanges ].

	self assert: ranges notNil.
	self assert: ranges size equals: 2 ] ensure: [ LibC system: 'kill ' , pid printString ]
