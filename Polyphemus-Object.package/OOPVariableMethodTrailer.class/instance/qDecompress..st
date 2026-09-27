decoding
qDecompress: someBytes

	"Pharo's qCompress: undone: the eleven commonest characters in one nibble, the next 52 in
	two, any other in three."

	| table input peek nextNibble |
	table := 'ear tonsilcmbdfghjkpquvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ012345[]()'.
	input := ReadStream on: someBytes.
	peek := true.
	nextNibble := [
	              peek
		              ifTrue: [ peek := false. input peek ifNil: [ 0 ] ifNotNil: [ :byte | byte // 16 ] ]
		              ifFalse: [ peek := true. input next ifNil: [ 0 ] ifNotNil: [ :byte | byte \\ 16 ] ] ].
	^ (String streamContents: [ :stream |
		   [ input atEnd ] whileFalse: [
			   | nibble |
			   nibble := nextNibble value.
			   nibble = 0
				   ifTrue: [
					   input atEnd ifFalse: [
						   stream nextPut: (Character value: nextNibble value * 16 + nextNibble value) ] ]
				   ifFalse: [
					   nibble <= 11
						   ifTrue: [ stream nextPut: (table at: nibble) ]
						   ifFalse: [ stream nextPut: (table at: nibble - 12 * 16 + nextNibble value) ] ] ] ])
		  asByteArray utf8Decoded
