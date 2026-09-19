checking
readability

	"How much of this memory can honestly be read. Worked out once and kept: a dump does not
	change while we look at it."

	^ readability ifNil: [ readability := SpurReadability of: self ]
