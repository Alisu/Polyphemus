decoding
kinds

	"Pharo's trailer kinds, by the six high bits of the last byte; 63 (from 252) is a plain
	source pointer."

	| kinds |
	kinds := Array new: 64 withAll: #Undefined.
	#( #NoTrailer #ClearedTrailer #TempsNamesQCompress #TempsNamesZip #SourceBySelector
	   #SourceByStringIdentifier #EmbeddedSourceQCompress #EmbeddedSourceZip
	   #VarLengthSourcePointer #ExtendedKind #NativeCodeTrailer #EmbeddedSource
	   #EmbeddedSourceWide ) doWithIndex: [ :each :index | kinds at: index put: each ].
	kinds at: 64 put: #SourcePointer.
	^ kinds
