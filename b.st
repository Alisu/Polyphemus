tests
testTheFramesWeFoundAreInTheVMsStackPages

	"The frames reached from married contexts all lie in the memory the VM gave its stack
	pages: numStackPages pages of bytesPerPage, from stackBasePlus1 - 1."

	| memory low high |
	memory := StackOfADumpTest memory.
	low := (variables at: 'stackBasePlus1') - 1.
	high := low + ((variables at: 'numStackPages') * (variables at: 'bytesPerPage')).

	(memory vmLayout raw framePointersIn: memory) do: [ :each |
		self assert: (each between: low and: high) ]
