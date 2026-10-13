running
requireAHostThatReproducesTheFixture

	"Skip where this host compiles the method into other bytes than the file's: temporaries are
	only named in such code (#6). TemporariesOnTheTargetImageTest checks the same on the target's
	own image, the build this host is made from."

	(self frameDescribed: 'SessionManager>>snapshot:andQuit:') faithfulCompiledCode ifNil: [
		self skip:
			'this host lays out SessionManager>>snapshot:andQuit: differently from the fixture, '
			, 'so its temporaries are not named here (#6)' ]
