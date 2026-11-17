helpers
heapMappingOfSelf

	"The mapping holding this image's heap, start -> limit, found without copying the heap."

	| live raw |
	live := LinuxProcessMemory onSelf.
	^ [
	  raw := SpurRawHeap on: live.
	  raw mappingStart -> raw mappingLimit ] ensure: [ live close ]
