literals
stringFor: aString

	"A string of the image's own with those characters. Bytes only: a wide one is a different
	class and a different format, and nothing asks for one yet."

	| oop |
	(aString allSatisfy: [ :each | each asInteger < 256 ]) ifFalse: [
		^ self error: 'this image would have to be given a wide string' ].
	oop := self allocateBytes: aString size ofClassNamed: 'ByteString'.
	1 to: aString size do: [ :each |
		self byteAt: oop + 8 + each - 1 put: (aString at: each) asInteger ].
	^ oop
