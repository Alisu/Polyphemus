tests
testAMethodWithoutSourceStillDisassembles

	"The candle image ships no sources file, so source reads answer nil. A frame must
	still show something: its bytecodes, which are in the image by definition."

	| context |
	context := (reifiedMemory contextsOfProcess: reifiedMemory reifiedActiveProcess) first.

	self assert: (reifiedMemory sourceOfContext: context) isNil.
	self deny: (reifiedMemory disassemblyOfContext: context) isEmpty
