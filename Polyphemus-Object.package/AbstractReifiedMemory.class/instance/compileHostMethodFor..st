highlighting
compileHostMethodFor: anActivation

	"Compile this activation's method here, from its own source, against the class it came
	from, and hand it back only if it is byte for byte what the file holds.

	Sources are embedded in what we build: a method compiled here has no source pointer into
	that image's sources file, and without its text the syntax tree comes back as a
	decompilation, whose offsets belong to text nobody wrote."

	^ [
	  | home source compiler host |
	  home := anActivation homeMethod.
	  source := home getSourceFromFile.
	  (source isNil or: [ source isEmpty ])
		  ifTrue: [ nil ]
		  ifFalse: [
			  compiler := OpalCompiler new.
			  compiler class: anActivation receiver oopClass.
			  compiler source: source.
			  compiler options: #( + optionSkipSemanticWarnings + optionEmbeddSources ).
			  compiler compilationContext compiledMethodClass: CompiledMethod.
			  host := compiler compile.
			  (self host: host matchesOop: home)
				  ifTrue: [ host ]
				  ifFalse: [ nil ] ] ]
		  on: Error
		  do: [ :e | nil ]
