tests
testAProcessIsFoundByItsName

	| process |
	process := Polyphemus processNamed: 'Morphic UI Process' in: memory.
	self assert: (Polyphemus nameOfProcess: process) equals: 'Morphic UI Process'.
	self assert: (memory contextsOfProcess: process) notEmpty
