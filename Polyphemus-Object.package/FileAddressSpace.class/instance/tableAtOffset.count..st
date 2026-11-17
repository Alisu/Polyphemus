reading
tableAtOffset: anOffset count: aCount

	"The bytes of a table the format says is there, whole. One the file does not hold whole is no
	table to index: the file is cut short or damaged, and refused saying so (#211)."

	| bytes |
	bytes := self bytesAtOffset: anOffset count: aCount.
	bytes size = aCount ifFalse: [
		^ UnknownFormat signal: 'a table of ' , aCount printString , ' bytes at offset ' , anOffset printString
			  , ' runs past the end of the file: cut short, or damaged' ].
	^ bytes
