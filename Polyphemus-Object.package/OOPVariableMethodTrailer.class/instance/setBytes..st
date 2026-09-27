initialization
setBytes: someBytes

	bytes := someBytes.
	kind := self class kinds at: (bytes at: bytes size) >> 2 + 1.
	kind == #SourcePointer ifTrue: [ ^ self decodeSourcePointer ].
	kind == #VarLengthSourcePointer ifTrue: [ ^ self decodeVarLengthSourcePointer ].
	kind == #NoTrailer ifTrue: [ ^ size := 4 ].
	(#( #EmbeddedSource #EmbeddedSourceWide #EmbeddedSourceQCompress #EmbeddedSourceZip
	    #ClearedTrailer #TempsNamesQCompress #TempsNamesZip ) includes: kind) ifTrue: [
		^ self decodeEmbedded ].
	self error: 'a method trailer of kind ' , kind , ', which no image holds'
