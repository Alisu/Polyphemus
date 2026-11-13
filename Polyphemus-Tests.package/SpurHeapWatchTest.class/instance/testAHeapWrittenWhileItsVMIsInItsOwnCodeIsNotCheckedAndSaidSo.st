tests
testAHeapWrittenWhileItsVMIsInItsOwnCodeIsNotCheckedAndSaidSo

	"#165: in its own code and not at rest, the VM may have a chunk off its free list and not yet
	an object; the check would blame the write. It is left out, and counted."

	| memory watch |
	memory := StoppedVMDouble on: (ByteArray new: 16384) at: 16r100000.
	memory stopped: 'in its own code, not at rest'.
	watch := SpurHeapWatch during: [
		         memory storeBytes: #[ 1 2 3 ] at: 16r100000.
		         memory resume ].
	self assert: watch problems isEmpty.
	self assert: watch unchecked size equals: 1.
	self assert: (watch unchecked first includesSubstring: 'in its own code')
