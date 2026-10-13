tests
testCogsMapIsReadInTheProcessorsInstructions

	"A CogMethod's map counts machine code in the processor's instructions: bytes on x86-64,
	four-byte words on arm64. Read with the wrong one, every machine code pc maps wrong."

	self assert: (OOPCogLayout backEndFor: #x86_64) codeGranularity equals: 1.
	self assert: (OOPCogLayout backEndFor: #aarch64) codeGranularity equals: 4
