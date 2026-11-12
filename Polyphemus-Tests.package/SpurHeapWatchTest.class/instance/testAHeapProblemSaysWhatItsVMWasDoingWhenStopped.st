tests
testAHeapProblemSaysWhatItsVMWasDoingWhenStopped

	"#165: at rest or in machine code, the VM is in no allocation of its own and a problem is ours;
	in its own code it may be the VM's, half way. The problem says which."

	| memory watch |
	memory := StoppedVMDouble on: (ByteArray new: 16384) at: 16r100000.
	memory stopped: 'in machine code'.
	watch := SpurHeapWatch during: [
		         memory storeBytes: #[ 1 2 3 ] at: 16r100000.
		         memory resume ].
	self assert: watch problems notEmpty.
	self assert: (watch problems allSatisfy: [ :each | each endsWith: '(its VM stopped in machine code)' ])
