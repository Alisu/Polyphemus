tests
testTheVirtualMachinesOwnObjectsArePaintedApart

	"Class indexes the VM keeps for itself (VMMaker's puns): a segment bridge (3), and 16 to 31,
	class table pages, weak arrays, word arrays... Ordinary classes start at 32."

	| painter |
	painter := self painterFor: #( #( 3 1 1 ) #( 16 2 1 ) #( 31 1 1 ) #( 32 1 1 ) ) bytesPerPixel: 8.

	self
		assert: (self categoriesOf: painter upTo: 7)
		equals: #( #virtualMachine #virtualMachine #virtualMachine #virtualMachine #virtualMachine #virtualMachine #pointers #pointers )
