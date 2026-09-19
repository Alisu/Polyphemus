testing
refuseIfMachineCode

	"Raise SpurCannotRead for a JIT frame: Cog lays frames out differently, so the
	interpreter's offsets would read the wrong words."

	self isMachineCodeFrame ifTrue: [
		^ (SpurCannotRead new
			   level: #frame
			   reason: #itIsAMachineCodeFrameAndWeHaveNoJITMapYet) signal ]
