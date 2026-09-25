tests
testAnImageFileTakesOnlyAFixThatFits

	"A copy of the file has nowhere to make room, so a longer fix is refused by name."

	| method fix |
	method := self aMethodWithAComparison.
	method ifNil: [ ^ self fail: 'no method of Integer recompiles here and holds a comparison' ].
	fix := SpurMethodFix on: reading into: (SpurWritableImageFile on: path).

	self
		should: [
			fix
				apply: (self
						 statementPutInto: method getSourceFromFile
						 source: '''polyphemus'' size = 10 ifTrue: [ ]. ')
				to: method ]
		raise: Error
		withExceptionDo: [ :error |
			self assert: (error messageText includesSubstring: 'cannot make room') ]
