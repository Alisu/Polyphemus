helpers
rawHeapWith: someVMVariables

	"A reader on one page of old space, told its VM's variables."

	| regions |
	regions := RegionsDouble new.
	regions region: 16r100000 bytes: (ByteArray new: 4096) writable: false.
	^ (SpurRawHeap on: regions from: 16r100000 to: 16r101000)
		  setVMVariables: someVMVariables;
		  yourself
