tests
testTheNewestFrameOfEachProcessKnowsWhereItIs

	"A suspended process's newest frame is the head of its page, and the VM left its ip on
	top of the page's stack. An interpreted one therefore has a pc within its bytecodes; a
	machine code one still waits on Cog's map."

	| tops |
	tops := memory allReifiedProcesses
		        collect: [ :each | (memory activationsOfProcess: each) ifEmpty: [ nil ] ifNotEmpty: [ :stack | stack first ] ]
		        thenSelect: [ :each | each notNil and: [ each isStackFrame and: [ each isMachineCodeFrame not ] ] ].

	self assert: tops notEmpty.
	tops do: [ :each |
		self assert: each pc notNil.
		self
			assert: (each pc - (memory firstBytecodePCOf: each compiledCode)
				 between: 0
				 and: each compiledCode endPC) ]
