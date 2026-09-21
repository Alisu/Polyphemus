highlighting
compileHostSource: aString for: aReifiedClass

	"That source compiled here as the image's own compiler would, with its tree: {method.
	tree}. Nothing when it does not compile -- and a syntax error is no Error, so it is named
	here or it would take the whole run with it (#29)."

	^ [
	  | compiler tree |
	  compiler := OpalCompiler new.
	  compiler class: aReifiedClass.
	  compiler source: aString.
	  compiler options:
		  (self compilerOptionsWith: #( + optionSkipSemanticWarnings + optionEmbeddSources )).
	  compiler compilationContext compiledMethodClass: CompiledMethod.
	  tree := compiler parse.
	  compiler doSemanticAnalysis.
	  Array with: tree generateWithSource with: tree ]
		  on: Error , SyntaxErrorNotification
		  do: [ :e | nil ]
