tests
testAVMThatDoesNotSayIsNotAsked

	"A variable the VM library does not name is refused by name, and the heap is read without it."

	<readsAnUnsoundHeap>
	| raw |
	raw := self rawHeapWith: (VMVariablesDouble on: RegionsDouble new at: Dictionary new).

	self assert: raw statedEndOfMemory isNil.
	self assert: raw statedSpecialObjectsOop isNil.
	self assert: raw liveYoungRanges isNil.
	self assert: raw codeZone equals: false.
	raw findYoungMapping.
	self assert: raw youngMappingStart isNil
