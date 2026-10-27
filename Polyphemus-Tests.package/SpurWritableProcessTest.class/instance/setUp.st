running
setUp

	| variables |
	super setUp.
	process := ProcessMemoryOfBytes on: (ByteArray new: 4096) at: 16r10000.
	variables := VMVariablesDouble on: process at: {
			             ('newSpaceStart' -> 16r10000).
			             ('newSpaceEnd' -> 16r10008).
			             ('rememberedSet' -> 16r10010).
			             ('rememberedSetSize' -> 16r10018).
			             ('rememberedSetLimit' -> 16r10020) } asDictionary.
	{ 16r10100. 16r10400. 16r10800. 0. 8 } withIndexDo: [ :each :index |
		process storeWord: each at: 16r10000 + (index - 1 * 8) ].
	memory := SpurWritableProcess on: process.
	memory instVarNamed: 'variables' put: variables
