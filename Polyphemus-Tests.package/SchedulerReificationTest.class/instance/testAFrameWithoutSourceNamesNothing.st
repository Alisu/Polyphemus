tests
testAFrameWithoutSourceNamesNothing

	"Without source, temporaries get no names, not decompiler inventions like tmp1."

	| frame |
	frame := (reifiedMemory contextsOfProcess: reifiedMemory reifiedActiveProcess) first.

	self assert: frame tempNames isEmpty.
	self should: [ frame tempNamed: 'anything' ] raise: Error
