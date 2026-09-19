accessing
endPC

	"The last byte of code, trailer excluded. A trailer that cannot fit, in a hand-built or
	damaged method, is not subtracted."

	| trailerSize |
	trailerSize := [ self trailer size ] on: Error do: [ :e | 0 ].
	(trailerSize between: 0 and: self numberOfBytecodes - 1) ifFalse: [
		trailerSize := 0 ].
	^ self initialPC + self numberOfBytecodes - trailerSize - 1
