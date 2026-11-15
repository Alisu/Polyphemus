tests
testEmbeddedSourceThatDoesNotDecodeIsRefusedByNameWhateverItsKind

	"#118: two bytes that are no UTF-8 as wide source, the same as zipped source, and compressed
	source with a code no compressor writes (the second sixteen characters, the zeroth of them)."

	self
		should: [ OOPVariableMethodTrailer on: #[ 16r10 255 254 2 48 ] ]
		raise: UnknownFormat
		withExceptionDo: [ :refusal | self assert: (refusal messageText beginsWith: 'a method trailer whose source does not decode: ') ].
	self
		should: [ OOPVariableMethodTrailer on: #[ 16r10 255 254 2 28 ] ]
		raise: UnknownFormat
		withExceptionDo: [ :refusal | self assert: (refusal messageText beginsWith: 'a method trailer whose source does not decode: ') ].
	self
		should: [ OOPVariableMethodTrailer on: #[ 16r10 16rC0 1 24 ] ]
		raise: UnknownFormat
		withExceptionDo: [ :refusal |
			self assert: refusal messageText equals: 'a method trailer whose compressed source has a code no compressor writes' ]
