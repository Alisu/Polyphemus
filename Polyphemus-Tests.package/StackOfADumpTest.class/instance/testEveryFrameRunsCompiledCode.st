tests
testEveryFrameRunsCompiledCode

	| frames |
	frames := self allFrames.

	self assert: frames size >= 58.
	frames do: [ :each |
		self assert: (each compiledCode isCompiledMethodOop or: [ each compiledCode isCompiledBlockOop ]) ]
