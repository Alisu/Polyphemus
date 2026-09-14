context protocol
astScope

	"The debugger asks a scope for its temporaries. Naming them needs the method's
	syntax tree analysed against the classes of the image it came from, which stage
	one does not do yet, so answer an empty scope: the debugger then shows the
	receiver and the stack, which is what a snapshot can honestly offer."

	^ OOPSnapshotScope new
