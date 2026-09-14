tests
testADamagedImageStillOpens

	"The point of stage one. This image was damaged in its file, by something other than
	us, and it is not repaired anywhere: reading it has to work, because an image nobody
	damaged is not the one anybody needs a debugger for."

	self deny: reifiedMemory allReifiedProcesses isEmpty.
	self assert: reifiedMemory reifiedSpecialObjectArray isNotNil
