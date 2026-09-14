accessing
endPC

	"The last byte of code. A method's bytes end with a trailer -- four or five of them,
	saying where its source is -- and that is not code. Counting it made every method look
	longer than the code compiled from its own source, and any disassembly ran off the end
	of the method and into the source pointer.

	The trailer is only believed when it could be one: a method built by hand, or one in a
	damaged image, decodes to whatever the last bytes happen to say, and a trailer of a
	thousand bytes in a method of five would put the end of the method before its
	beginning. When it cannot be believed, none of it is taken off -- too long is wrong,
	but negative is nonsense."

	| trailerSize |
	trailerSize := [ self trailer size ] on: Error do: [ :e | 0 ].
	(trailerSize between: 0 and: self numberOfBytecodes - 1) ifFalse: [
		trailerSize := 0 ].
	^ self initialPC + self numberOfBytecodes - trailerSize - 1
