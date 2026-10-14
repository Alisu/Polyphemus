helpers
assertTheHeapOfThisVirtualMachineStartsAt: anAddress

	"As this VM answers itself (getOldSpaceStart, VM 10 on); VM 9 has no such call, so there a
	pinned object of ours must lie above it, in memory we read (#80)."

	| library object |
	library := self vmLibraryOf: MacProcessMemory onSelf.
	(MacProcessMemory dlsym: -2 named: 'getOldSpaceStart') = 0 ifFalse: [
		^ self assert: anAddress equals: (self class oldSpaceStartFrom: library path) ].
	object := ByteArray new: 16.
	object pin.
	self assert: anAddress < (PointerUtils oopForObject: object).
	self assert: (MacProcessMemory onSelf hasAddress: anAddress)
