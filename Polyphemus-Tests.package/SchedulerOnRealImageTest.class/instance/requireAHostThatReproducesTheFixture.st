running
requireAHostThatReproducesTheFixture

	"Skip where this host compiles the method into bytes other than the file's. Temporaries
	are only named in such code (#6), so there is nothing to check; highlighting does not
	need this, since it matches sends when the bytes differ (#4). TemporariesOnTheTargetImageTest
	checks the same on the target's own image, which reproduces on Pharo 12 and later, not on
	Pharo 11, whose host is an older build than its target."

	(self frameDescribed: 'SessionManager>>snapshot:andQuit:') faithfulCompiledCode ifNil: [
		self skip:
			'this host lays out SessionManager>>snapshot:andQuit: differently from the fixture, '
			, 'so its temporaries are not named here (#6)' ]
