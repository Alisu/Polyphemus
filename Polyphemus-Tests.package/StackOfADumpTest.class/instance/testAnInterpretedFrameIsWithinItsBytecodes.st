tests
testAnInterpretedFrameIsWithinItsBytecodes

	"Its pc comes from the ip its callee saved, converted as CoInterpreter does. It counts
	from the start of the method, as a context's does. Only the top frame of a page has no
	callee, and so no pc yet."

	| located |
	located := self allFrames select: [ :each | each isMachineCodeFrame not and: [ each pc notNil ] ].

	self assert: located size >= 20.
	located do: [ :each |
		self
			assert: (each pc - (memory firstBytecodePCOf: each compiledCode)
				 between: 0
				 and: each compiledCode endPC) ]
