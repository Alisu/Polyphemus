examples
readsABrokenHeap

	"A heap built during a test, as a reading builds one, which is not one: zeros where a heap
	should start."

	SpurRawHeap on: (ByteArrayAddressSpace on: (ByteArray new: 4096) at: 16r100000) from: 16r100000 to: 16r101000
