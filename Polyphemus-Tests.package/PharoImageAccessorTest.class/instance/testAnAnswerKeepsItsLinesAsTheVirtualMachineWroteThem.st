tests
testAnAnswerKeepsItsLinesAsTheVirtualMachineWroteThem

	"Dropping the Windows VM's startup line must leave the rest of an answer as it was written."

	| answer |
	answer := 'one' , String lf , 'two' , String lf.
	self assert: (self withoutStartupNoise: answer) equals: answer.
	self
		assert: (self withoutStartupNoise:
				 '[ERROR] x sqMakeMemoryNotExecutableFromTo (y):VirtualProtect(x,y,PAGE_EXECUTE_READWRITE): No error'
				 , String lf , answer)
		equals: answer
