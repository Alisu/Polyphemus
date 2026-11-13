tests
testATextTheVMDoesNotSayIsNil

	"A character array the VM library does not name, as imageName from VM 12, is refused by name."

	<readsAnUnsoundHeap>
	| raw |
	raw := self rawHeapWith: (VMVariablesDouble on: RegionsDouble new at: Dictionary new).

	self assert: (raw statedText: 'imageName') isNil
