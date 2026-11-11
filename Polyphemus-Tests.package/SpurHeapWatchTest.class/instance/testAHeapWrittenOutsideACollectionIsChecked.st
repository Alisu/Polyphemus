tests
testAHeapWrittenOutsideACollectionIsChecked

	"#173: the check of #141 still runs on a write into the heap of a VM that collects nothing."

	| memory watch |
	memory := StoppedVMDouble on: (ByteArray new: 16384) at: 16r100000.
	watch := SpurHeapWatch during: [
		         memory storeBytes: #[ 1 2 3 ] at: 16r100000.
		         memory resume ].
	self assert: watch problems notEmpty.
	self assert: watch unchecked isEmpty
