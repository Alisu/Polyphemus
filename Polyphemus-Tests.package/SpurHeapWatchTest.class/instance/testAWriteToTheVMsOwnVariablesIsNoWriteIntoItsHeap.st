tests
testAWriteToTheVMsOwnVariablesIsNoWriteIntoItsHeap

	"#173: signalling a semaphore writes the VM's variables; its heap, untouched, is not checked."

	| memory watch |
	memory := StoppedVMDouble on: (ByteArray new: 16384) at: 16r100000.
	watch := SpurHeapWatch during: [
		         memory storeBytes: #[ 1 2 3 ] at: memory dataAddress.
		         memory resume ].
	self assert: watch problems isEmpty.
	self assert: watch unchecked isEmpty
