highlighting
compileHostSource: aString for: aReifiedClass

	"That source compiled here as the image's own compiler would, with its tree: {method.
	tree}. A pc maps to source only through the tree that made the method (#4)."

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
		  on: Error
		  do: [ :e | nil ]
