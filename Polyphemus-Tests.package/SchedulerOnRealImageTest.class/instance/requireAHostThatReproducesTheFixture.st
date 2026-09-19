running
requireAHostThatReproducesTheFixture

	"Skip when this host compiles the fixture's source into different bytecodes, as Pharo 11
	does: highlighting, block matching and naming then answer nothing."

	(self frameDescribed: 'SessionManager>>snapshot:andQuit:') faithfulCompiledCode ifNil: [
		self skip:
			'this host compiles the fixture''s source into different bytecodes, so nothing is '
			, 'highlighted, matched or named here. The fixture is pinned to Pharo 10 and the '
			, 'highlighting is built by recompiling in the host.' ]
