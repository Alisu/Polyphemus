tests
testAFixThatFitsGoesWhereTheImageIsWrittenFrom

	"Both kinds of fix go into one memory, so the image written from it has both. Code that
	fits once went to a copy of the file while longer code went to VMMaker's memory."

	| method class swapped new memory address |
	method := self aMethodWithAComparison.
	method ifNil: [ ^ self fail: 'no method of Integer recompiles here and holds a comparison' ].
	class := reading oopClassNamed: 'Integer'.
	swapped := method getSourceFromFile copyReplaceAll: ' < ' with: ' <= '.
	new := (reading compileHostSource: swapped for: class) first.
	memory := SpurWritableVMMakerMemory on: reading.

	self
		assert: ((SpurMethodFix on: reading into: memory) apply: swapped to: method)
		equals: #wroteItWhereItWas.
	address := method address + 8 + (new initialPC - 1).
	self
		assert: (memory bytesAt: address count: new endPC - new initialPC + 1)
		equals: ((new initialPC to: new endPC) collect: [ :each | new at: each ])
