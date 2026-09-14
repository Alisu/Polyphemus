context protocol
receiver

	"The object this activation is running in. Named as a context names it, because a frame
	and a context are the same activation and everything reading a stack should be able to
	ask either."

	^ self oopReceiver
