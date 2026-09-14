highlighting
computeFaithfulCompiledCode

	"Compile this frame's method here, from its own source, against the class it came from,
	and hand it back only if it is byte for byte what the file holds.

	Sources are embedded in what we build: a method compiled here has no source pointer
	into that image's sources file, and without its text the syntax tree comes back as a
	decompilation, whose offsets belong to text nobody wrote."

	| method source compiler host |
	method := self homeMethod.
	source := method getSourceFromFile.
	(source isNil or: [ source isEmpty ]) ifTrue: [ ^ nil ].

	compiler := OpalCompiler new.
	compiler class: self receiver oopClass.
	compiler source: source.
	compiler options: #( + optionSkipSemanticWarnings + optionEmbeddSources ).
	compiler compilationContext compiledMethodClass: CompiledMethod.
	host := compiler compile.

	(self code: host matches: method) ifFalse: [ ^ nil ].
	self isBlockContext ifFalse: [ ^ host ].
	^ self hostBlockOf: host
