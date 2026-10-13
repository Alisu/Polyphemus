tests
testAFrameWhoseMethodFieldIsOutsideTheCodeZoneHoldsNoPc

	"Caught while a frame is being built, its method field may hold what the stack held before,
	below the heap but outside the code zone: no pc lies there (an MNU on Pharo 13, 2026-10-05).
	Here the field holds a zero found on a stack page."

	| core layout raw variables fp |
	core := (self machineCodeCoreWhere: #inItsFrame) ifNil: [
		        ^ self skip: 'no gdb here, or no core caught in machine code' ].
	layout := (SpurDumpedMemory on: (ElfCoreDump on: core)) reifiedMemory vmLayout.
	raw := layout raw.
	variables := raw vmVariables.
	fp := nil.
	variables stackPages do: [ :page |
		fp ifNil: [
			(page baseAddress - (variables at: 'bytesPerPage') + 8 to: page baseAddress by: 8)
				detect: [ :each | (raw wordOfFrame: each at: -8) = 0 ]
				ifFound: [ :each | fp := each ]
				ifNone: [  ] ] ].
	self assert: fp notNil.
	self deny: (raw isMachineCodeAddress: 0).

	self assert: (layout isMachineCodeFrame: fp).
	self deny: (layout isInstructionPointer: 16 inMethodOf: fp)
