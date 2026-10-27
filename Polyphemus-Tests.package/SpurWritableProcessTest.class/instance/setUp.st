running
setUp

	| names |
	super setUp.
	process := ProcessMemoryOfBytes on: (ByteArray new: 16r4000) at: 16r10000.
	names := #( 'newSpaceStart' 'newSpaceEnd' 'rememberedSet' 'rememberedSetSize' 'rememberedSetLimit' 'freeStart' 'scavengeThreshold' ).
	{ 16r11000. 16r13000. 16r10100. 0. 8. 16r11000. 16r13000 } withIndexDo: [ :each :index |
		process storeWord: each at: 16r10000 + (index - 1 * 8) ].
	memory := SpurWritableProcess on: process.
	memory instVarNamed: 'variables' put: (VMVariablesDouble
			 on: process
			 at: (names collectWithIndex: [ :each :index | each -> (16r10000 + (index - 1 * 8)) ]) asDictionary)
