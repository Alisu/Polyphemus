highlighting
compileHostSource: aString for: aReifiedClass

	"That source compiled here as the image's own compiler would, with its tree: {method.
	tree}. Nothing when it does not compile: a syntax error is no Error (#29), and Pharo 12
	makes it a faulty tree."

	^ [
	  | compiler tree |
	  compiler := OpalCompiler new.
	  compiler class: aReifiedClass.
	  compiler source: aString.
	  compiler options:
		  (self compilerOptionsWith: #( + optionSkipSemanticWarnings + optionEmbeddSources )).
	  compiler compilationContext compiledMethodClass: CompiledMethod.
	  tree := compiler parse.
	  tree isFaulty ifTrue: [ ^ nil ].
	  compiler doSemanticAnalysis.
	  Array with: tree generateWithSource with: tree ]
		  on: self class syntaxErrors
		  do: [ :e | nil ]
