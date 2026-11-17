reading
whereIsStuck: aPid reading: aReifiedMemory

	"As whereIsStuck:, and when its VM is in a C call, the Smalltalk process above that call, its
	frame in C, and the first frame below it outside the FFI's own classes (#18)."

	^ (self whereIsStuck: aPid) sayingTheSmalltalkAboveCIn: aReifiedMemory