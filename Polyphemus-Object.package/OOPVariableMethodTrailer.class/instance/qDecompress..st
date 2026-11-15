decoding
qDecompress: someBytes

	"Pharo's qCompress: undone: the eleven commonest characters in one nibble, the next 52 in
	two, any other in three. A code that names no character is refused by name."

	| table input peek nextNibble text |
	table := 'ear tonsilcmbdfghjkpquvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ012345[]()'.
	input := ReadStream on: someBytes.
	peek := true.
	nextNibble := [
	              peek
		              ifTrue: [ peek := false. input peek ifNil: [ 0 ] ifNotNil: [ :byte | byte // 16 ] ]
		              ifFalse: [ peek := true. input next ifNil: [ 0 ] ifNotNil: [ :byte | byte \\ 16 ] ] ].
	text := String streamContents: [ :stream |
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
						   ifFalse: [
							   | index |
							   index := nibble - 12 * 16 + nextNibble value.
							   index = 0 ifTrue: [
								   ^ UnknownFormat signal: 'a method trailer whose compressed source has a code no compressor writes' ].
							   stream nextPut: (table at: index) ] ] ] ].
	^ self decoded: [ text asByteArray utf8Decoded ]
