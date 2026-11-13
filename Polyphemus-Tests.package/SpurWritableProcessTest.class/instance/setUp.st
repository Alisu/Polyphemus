running
setUp

	"New space from 16r11000 to 16r13000: past space its first quarter, holding 16r100 bytes of
	survivors, eden its second half, empty. Its VM stopped in machine code, collecting nothing."

	| names |
	super setUp.
	process := ProcessMemoryOfBytes on: (ByteArray new: 16r4000) at: 16r10000.
	names := #( 'newSpaceStart' 'newSpaceEnd' 'rememberedSet' 'rememberedSetSize' 'rememberedSetLimit' 'freeStart' 'scavengeThreshold' 'pastSpaceStart' 'pastSpace' 'pastSpaceLimit' 'gcPhaseInProgress' 'marking' ).
	{ 16r11000. 16r13000. 16r10100. 0. 8. 16r12000. 16r13000. 16r11100. 16r11000. 16r11800. 0. 0 } withIndexDo: [ :each :index |
		process storeWord: each at: 16r10000 + (index - 1 * 8) ].
	memory := SpurWritableProcess on: process.
	memory instVarNamed: 'variables' put: (VMVariablesDouble
			 on: process
			 at: (names collectWithIndex: [ :each :index | each -> (16r10000 + (index - 1 * 8)) ]) asDictionary).
	memory variables machineCode: true
