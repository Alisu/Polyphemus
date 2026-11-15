highlighting
whyHostSourceDoesNotCompile: aString for: aReifiedClass

	"The compiler's first error in that source, as compileHostSource:for: compiles it: its reason
	-> where it points. Nil when it compiles, or when this Pharo keeps no notices on its tree."

	| options |
	options := memory compilerOptionsWith: #( + optionSkipSemanticWarnings + optionEmbeddSources ).
	^ ForeignCode
		  askingPharo: [
			  | compiler tree |
			  compiler := OpalCompiler new.
			  compiler class: aReifiedClass.
			  compiler source: aString.
			  compiler options: options.
			  tree := compiler parse.
			  (tree respondsTo: #allNotices) ifFalse: [ ^ nil ].
			  tree allNotices
				  detect: [ :each | each isError ]
				  ifFound: [ :each | each messageText -> each position ]
				  ifNone: [ nil ] ]
		  ifItFails: [ nil ]
