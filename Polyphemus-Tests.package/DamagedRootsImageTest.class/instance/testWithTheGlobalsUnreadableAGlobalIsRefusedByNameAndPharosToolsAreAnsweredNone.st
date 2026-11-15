tests
testWithTheGlobalsUnreadableAGlobalIsRefusedByNameAndPharosToolsAreAnsweredNone

	"#118: with the array of the globals unreadable, every global was said absent, and that was
	kept for the reading. Asked by name it is refused, each time; Pharo's compiler, which asks a
	class for a binding, is answered none; classes are still found, through the class table."

	| point |
	point := reifiedMemory oopClassNamed: 'Point'.

	2 timesRepeat: [
		self
			should: [ reifiedMemory globalNamed: #Transcript ]
			raise: NotInTheReading
			withExceptionDo: [ :refusal |
				self assert: (refusal messageText beginsWith: 'the globals of this image do not read: ') ] ].
	self assert: (point bindingOf: #Transcript) isNil.
	self assert: point oopName equals: 'Point'
