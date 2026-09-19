highlighting
compileHostSourceFor: anActivation

	"The method compiled here from its source as the image's compiler would, with its tree:
	{method. tree}. A pc maps to source only through the tree that made the method (#4)."

	^ [
	  | source compiler tree method |
	  source := anActivation homeMethod getSourceFromFile.
	  (source isNil or: [ source isEmpty ])
		  ifTrue: [ nil ]
		  ifFalse: [
			  compiler := OpalCompiler new.
			  compiler class: anActivation receiver oopClass.
			  compiler source: source.
			  compiler options:
				  (self compilerOptionsWith: #( + optionSkipSemanticWarnings + optionEmbeddSources )).
			  compiler compilationContext compiledMethodClass: CompiledMethod.
			  tree := compiler parse.
			  compiler doSemanticAnalysis.
			  method := tree generateWithSource.
			  Array with: method with: tree ] ]
		  on: Error
		  do: [ :e | nil ]
