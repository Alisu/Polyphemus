running
requireAHostThatReproduces: aFrame

	"Skip where this host compiles the frame's method into bytes other than the file's, as
	Pharo 12's does Pharo 10's: its temporaries and pcs are only read in such code (#6).
	FramesOnTheTargetImageTest checks the same on the target's own image."

	aFrame faithfulCompiledCode ifNil: [
		self skip: 'this host lays out ' , aFrame printString
			, ' differently from the fixture (#6)' ]
