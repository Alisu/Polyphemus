testing
isReadable

	"Whether this frame can be read with the interpreter's layout. A JIT frame cannot."

	^ self isMachineCodeFrame not
