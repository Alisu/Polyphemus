tests
testAMethodWhoseEmbeddedSourceDoesNotDecodeRefusesItByNameWhateverItsKind

	"#118: three trailers saying they embed source, as wide text, zipped and compressed, over
	bytes that are none. Each is refused by name where the trailer or the source is asked, and
	the method still says its name and names no argument."

	| interval |
	interval := reifiedMemory oopClassNamed: 'Interval'.
	{ ('sum' -> 'whose source does not decode: '). ('anyOne' -> 'whose source does not decode: ').
	('reverseDo:' -> 'has a code no compressor writes') } do: [ :each |
		| method |
		method := interval methodNamed: each key ifAbsent: [ nil ].
		self
			should: [ method trailer ]
			raise: UnknownFormat
			withExceptionDo: [ :refusal | self assert: (refusal messageText includesSubstring: each value) description: each key ].
		self should: [ method sourceCode ] raise: UnknownFormat description: each key.
		self assert: method argumentNames isEmpty description: each key.
		self assert: method printString equals: 'Interval >> #' , each key ]
