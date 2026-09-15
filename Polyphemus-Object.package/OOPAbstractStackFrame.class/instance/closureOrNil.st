context protocol
closureOrNil

	"The closure a block activation is running. A frame says whether it is running one
	through its flags; reading the closure itself out of the frame is not done yet, so a
	block frame answers nil rather than something invented."

	^ nil
