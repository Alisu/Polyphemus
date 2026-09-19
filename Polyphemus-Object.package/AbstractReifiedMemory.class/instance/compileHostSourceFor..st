highlighting
compileHostSourceFor: anActivation

	"The activation's method compiled here from its own source as the image's compiler would
	have, with the syntax tree it was compiled from: {method. tree}. Kept together because
	a pc means a place in the source only through the tree that produced the method; the one
	Pharo would rebuild for it uses this host's defaults (#4)."

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
