tests
testTheDebuggerReadsTemporariesThroughTheMethodsDebugInfo

	"Pharo 14's debugger reads a context's temporaries through its method's debugInfo: the
	scope at the context's pc, which reads them from the context and knows the arguments."

	| frame scope |
	self requireAHostThatReproducesTheFixture.
	frame := self frameDescribed: 'SessionManager>>snapshot:andQuit:'.
	scope := frame method debugInfo debugScopeAt: frame pc.

	frame tempNames do: [ :each |
		self assert: (scope readVariableNamed: each fromContext: frame) equals: (frame tempNamed: each) ].
	"snapshot: save andQuit: quit | isImageStarting wait |"
	self assert: (scope isArgumentNamed: #save).
	self deny: (scope isArgumentNamed: #isImageStarting)
