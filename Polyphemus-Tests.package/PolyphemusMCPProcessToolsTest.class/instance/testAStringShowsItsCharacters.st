tests
testAStringShowsItsCharacters

	| row process name |
	row := self namedProcess.
	process := self inspect: (row at: 'address') in: self resource target.
	name := self inspect: ((self slotNamed: 'name' of: process) at: 'address') in: self resource target.
	self assert: ((name at: 'structuredContent') at: 'string') equals: (row at: 'name')
