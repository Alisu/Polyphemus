tests
testEveryFrameRunsCompiledCode

	"Each edition reads its own dump: 58 frames in the VM 9 one, 39 in the VM 10 one."

	| frames |
	frames := self allFrames.

	self assert: frames size >= 30.
	frames do: [ :each |
		self assert: (each compiledCode isCompiledMethodOop or: [ each compiledCode isCompiledBlockOop ]) ]
