naming
methodTrailerClassByShape

	"The trailer class the last bytes of two hundred of its methods tell
	(OOPVariableMethodTrailer class>>trailerClassOfMethodsEnding:); refused by name where they
	say neither kind. A class or a method that does not read on the way is refused as it is."

	| lastBytes |
	lastBytes := OrderedCollection new.
	self allClassesOop do: [ :each |
		(lastBytes size < 200 and: [ each isClassOop ]) ifTrue: [
			each reifiedMethods do: [ :method |
				(lastBytes size < 200 and: [ method isCompiledMethodOop ]) ifTrue: [
					| bytes |
					bytes := OOPCompiledCodeBytes on: method.
					lastBytes add: (bytes at: bytes size) ] ] ] ].
	^ (OOPVariableMethodTrailer trailerClassOfMethodsEnding: lastBytes) ifNil: [
		  NotInTheReading signal: 'how this image writes its methods'' trailers cannot be told: its CompiledMethod does not tell its methods, and the last bytes of '
			  , lastBytes size printString , ' of them say neither kind' ]
