tests
testItRefusesAFixThatWantsLiteralsTheImageHasNot

	"What it will not do, said plainly rather than done badly: the state that carries a
	method's pragmas is the image's own and is kept, so an edit that changes them is refused
	rather than installed with the wrong ones."

	| method source |
	method := self aMethodWithAComparison.
	method ifNil: [ ^ self fail: 'no method of Integer recompiles here and holds a comparison' ].
	source := method getSourceFromFile.
	(source includesSubstring: '<primitive:') ifFalse: [
		^ self skip: 'that method carries no pragma to change' ].
	source := source copyReplaceAll: '<primitive:' with: '<polyphemusWasHere> <primitive:'.

	self
		should: [ self fix apply: source to: method ]
		raise: Error
		withExceptionDo: [ :error |
			self assert: (error messageText includesSubstring: 'pragmas') ]
