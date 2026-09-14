contexts
isMarriedContext: aContextOop

	"A context married to a frame keeps its own frame pointer, as a small integer, in
	the slot where a divorced context keeps its sender. The rest of that stack lives
	in the frames of a stack page rather than in contexts.

	A snapshot on disk contains no married contexts: the VM divorces every frame
	before writing the image. We create one ourselves, because loading the image into
	the simulator marries the running process' context back to a frame."

	^ (aContextOop reifiedSlotAt: self contextSenderSlot) isImmediateOop
