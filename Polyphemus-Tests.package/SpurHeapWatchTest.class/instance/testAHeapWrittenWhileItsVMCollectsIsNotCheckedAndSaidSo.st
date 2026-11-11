tests
testAHeapWrittenWhileItsVMCollectsIsNotCheckedAndSaidSo

	"#173: caught in a collection, the VM itself has the free lists and the heap disagreeing; the
	check would blame the write. It is left out, and counted."

	| memory watch |
	memory := StoppedVMDouble on: (ByteArray new: 16384) at: 16r100000.
	memory collecting: 'collecting garbage (gcPhaseInProgress 1)'.
	watch := SpurHeapWatch during: [
		         memory storeBytes: #[ 1 2 3 ] at: 16r100000.
		         memory resume ].
	self assert: watch problems isEmpty.
	self assert: watch unchecked size equals: 1.
	self assert: (watch unchecked first includesSubstring: 'gcPhaseInProgress 1')
