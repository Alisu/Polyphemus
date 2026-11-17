tests
testAnAddressInsideAFunctionIsNamedAfterIt

	"The nearest symbol at or below an address, in the VM's own library."

	| library interpret |
	library := ElfSharedObject on: (PharoImageAccessor pathToTargetVM asFileReference parent / 'libPharoVMCore.so') fullName.
	interpret := library addressOf: 'interpret'.

	self assert: (library nameOfAddress: interpret) equals: 'interpret'.
	self assert: (library nameOfAddress: interpret + 16) equals: 'interpret'.
	self deny: (library nameOfAddress: interpret + (library sizeOf: 'interpret')) = 'interpret'
