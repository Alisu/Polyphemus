tests
testAVirtualMachineCaughtInMachineCodeShowsItsRunningProcess

	"Stopped in Cog's code, the newest frames are only in the thread's registers: x29, x28 and
	pc on arm64 (#17). Every machine code pc maps through Cog's map, read in arm64's four-byte
	instructions. Caught in its own frame within thirty stops."

	| pid stack memory caught refusals |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	pid := self launchSpinningTarget.
	caught := 0.
	refusals := Bag new.
	[
	(1 to: 30) do: [ :each |
		stack ifNil: [
			| reader |
			reader := MacProcessMemory on: pid.
			[
			reader whileStopped: [
				(VMVariables on: reader) wasRunningMachineCode ifTrue: [
					| dumped |
					caught := caught + 1.
					dumped := SpurDumpedMemory on: reader.
					([ dumped reifiedMemory vmLayout framesOfActiveProcess. true ]
						 on: SpurCannotRead
						 do: [ :e | refusals add: e messageText. false ]) ifTrue: [
						memory := dumped reifyEverything: dumped reifiedMemory.
						stack := memory activationsOfProcess: memory reifiedActiveProcess ] ] ] ] ensure: [
				reader close ].
			(Delay forMilliseconds: 50) wait ] ].

	self assert: caught > 0 description: 'never stopped in machine code'.
	self assert: stack notNil description: [ 'refused each time: ' , refusals asSet asArray printString ].
	self assert: stack first isMachineCodeFrame.
	self assert: (stack anySatisfy: [ :each | each method selector = #DoIt ]).
	self
		assert: (self assertEachPcFollowsTheSendAbove: stack in: memory) > 0
		description: 'no machine code frame under the newest: Cog''s map not checked' ] ensure: [
		LibC system: 'kill ' , pid printString ]
