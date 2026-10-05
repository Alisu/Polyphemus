tests
testTheDebuggerReadsTemporariesThroughTheMethodsDebugInfo

	"Read through the method's debugInfo at the frame's pc, as Pharo 14's debugger does: the
	same values, and the arguments known as such."

	| frame scope |
	self requireAHostThatReproducesTheFixture.
	frame := self frameDescribed: 'SessionManager>>snapshot:andQuit:'.
	scope := frame method debugInfo debugScopeAt: frame pc.

	frame tempNames do: [ :each |
		self assert: (scope readVariableNamed: each fromContext: frame) equals: (frame tempNamed: each) ].
	(self hostMethodOf: frame) argumentNames do: [ :each | self assert: (scope isArgumentNamed: each) ]
