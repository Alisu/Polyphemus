decoding
decodeVarLengthSourcePointer

	"Seven bits a byte, least significant last, a set high bit meaning more."

	| position shift value |
	position := bytes size - 1.
	shift := data := 0.
	[
	value := bytes at: position.
	data := (value bitAnd: 16r7F) << shift + data.
	position := position - 1.
	shift := shift + 7.
	value > 127 ] whileTrue.
	size := bytes size - position
