accessing
alignedByteSize

	"Forty-eight bytes: the header, then a word for the flag that left it."

	^ 40 + self baseHeaderSize
