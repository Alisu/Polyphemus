tests
testItRefusesAFixThatWantsLiteralsTheImageHasNot

	"What it will not do, said plainly rather than done badly. A literal frame that differs --
	even in its order, which an inlined ifTrue: is enough to change -- cannot be the old
	method's, and making one in the image is not wired to this yet."

	| method source |
	method := self aMethodWithAComparison.
	method ifNil: [ ^ self fail: 'no method of Integer recompiles here and holds a comparison' ].
	source := method getSourceFromFile.
	source := source copyReplaceAll: ' < ' with: ' < ''polyphemus'' size + '.

	self
		should: [ self fix apply: source to: method ]
		raise: Error
		withExceptionDo: [ :error |
			self assert: (error messageText includesSubstring: 'literals') ]
