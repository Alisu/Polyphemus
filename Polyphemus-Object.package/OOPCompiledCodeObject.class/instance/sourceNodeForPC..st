debugger protocol
sourceNodeForPC: aPC

	"Where a pc is in the source, asked of the code by Pharo 11's debugger: not known here.
	A block would need its host block found inside its method's, as a context does."

	^ OOPUnknownSourceNode new
