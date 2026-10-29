highlighting
compileHostSource: aString for: aReifiedClass doIt: aBoolean

	"That source compiled here as the image's own compiler would, with its tree: {method. tree}.
	A DoIt as the image ran it, with this host's defaults, the same Pharo's (#7); its source
	has no header, but Pharo 10's keeps one. Nil when it does not compile (#29)."

	aBoolean ifFalse: [
		^ self compileHostSource: aString for: aReifiedClass options:
			  (memory compilerOptionsWith: #( + optionSkipSemanticWarnings + optionEmbeddSources ))
			  headless: false ].
	^ (self compileHostSource: aString for: aReifiedClass options: #( + optionSkipSemanticWarnings ) headless: true)
		  ifNil: [ self compileHostSource: aString for: aReifiedClass options: #( + optionSkipSemanticWarnings ) headless: false ]
