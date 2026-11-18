tests
testAThreadInMachineCodeThatGivesNoFramePointerIsRefusedByName

	"#211: a thread caught in machine code gives its registers where the system does (a core,
	macOS); /proc gives a running thread no frame pointer. Its frames were then asked of nil:
	'receiver of between:and: is nil'. Refused as ours, saying what is missing."

	| variables raw |
	variables := (DefectiveReadDouble of: Object new)
		             when: #wasRunningMachineCode answer: [ true ];
		             when: #registersOfTheThreadInMachineCode answer: [
			             Dictionary new
				             at: #framePointer put: nil;
				             at: #stackPointer put: 16r7FFE0010;
				             at: #instructionPointer put: 16r1000;
				             yourself ];
		             yourself.
	raw := (DefectiveReadDouble of: Object new)
		       when: #vmVariables answer: [ variables ];
		       yourself.
	self
		should: [ (OOPCogLayout on: nil raw: raw) framesOfActiveProcess ]
		raise: SpurCannotRead
		withExceptionDo: [ :refusal | self assert: refusal reason equals: #itsThreadInMachineCodeGivesNoFramePointer ]
