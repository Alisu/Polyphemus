tests
testItRefusesAFixThatWantsLiteralsTheImageHasNot

	"What it will not do, said plainly rather than done badly: new code holding a block of its
	own needs a compiled block made in the image, and nothing makes one yet."

	| method source |
	method := self aMethodWithAComparison.
	method ifNil: [ ^ self fail: 'no method of Integer recompiles here and holds a comparison' ].
	source := self
		          statementPutInto: method getSourceFromFile
		          source: '(1 to: 2) collect: [ :each | each + 1 ]. '.

	self
		should: [ self fix apply: source to: method ]
		raise: Error
		withExceptionDo: [ :error |
			self assert: (error messageText includesSubstring: 'block') ]
