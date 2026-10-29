highlighting
compileHostSource: aString for: aReifiedClass options: someOptions headless: aBoolean

	"{method. tree} compiled here with someOptions, as statements without a method header when
	aBoolean. Nil when it does not compile: a syntax error is no Error (#29), and Pharo 12 makes it
	a faulty tree."

	^ [
	  | compiler tree |
	  compiler := OpalCompiler new.
	  compiler class: aReifiedClass.
	  compiler source: aString.
	  aBoolean ifTrue: [
		  (compiler respondsTo: #isScripting:)
			  ifTrue: [ compiler isScripting: true ]
			  ifFalse: [ compiler noPattern: true ] ].
	  compiler options: someOptions.
	  compiler compilationContext compiledMethodClass: CompiledMethod.
	  tree := compiler parse.
	  tree isFaulty ifTrue: [ ^ nil ].
	  compiler doSemanticAnalysis.
	  Array with: tree generateWithSource with: tree ]
		  on: memory class syntaxErrors
		  do: [ :e | nil ]
