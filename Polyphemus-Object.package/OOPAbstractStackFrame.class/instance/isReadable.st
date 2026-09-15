testing
isReadable

	"Whether this frame can be read with what we know. A machine code frame cannot: its method
	field is a CogMethod in the code zone rather than an object, its receiver sits at a
	different offset, and its instruction pointer is a machine address that only the JIT's own
	map can turn back into a place in the source.

	Reading one with the offsets for an interpreted frame would answer something for every
	question and mean none of it."

	^ self isMachineCodeFrame not
