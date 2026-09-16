running
requireAHostThatReproducesTheFixture

	"Skip, with a reason, on a host that compiles the fixture's source into different
	bytecodes than the fixture's own file holds.

	A snapshot carries no map from a pc to a place in its source, and no link from a compiled
	block to the block it came from. Both are rebuilt by compiling the method's source *here*
	and keeping the result only when the bytecodes come out identical to the file's. That
	check is the whole reason these answers can be trusted -- and on a host whose compiler
	differs from the one the fixture was pinned to, it never agrees: nothing is highlighted,
	no block is matched, no temporary is named.

	That is the tool refusing to guess, which is what it should do. Reported as a failure it
	looks like a regression in the fixture, so it is reported as a skip that says which host
	is wanted."

	(self frameDescribed: 'SessionManager>>snapshot:andQuit:') faithfulCompiledCode ifNil: [
		self skip:
			'this host compiles the fixture''s source into different bytecodes, so nothing is '
			, 'highlighted, matched or named here. The fixture is pinned to Pharo 10 and the '
			, 'highlighting is built by recompiling in the host.' ]
