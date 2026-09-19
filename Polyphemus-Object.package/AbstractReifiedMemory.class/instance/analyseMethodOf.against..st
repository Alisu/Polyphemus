naming
analyseMethodOf: aCompiledMethod against: aClass

	"Parse and analyse, or answer nil: a debugger that cannot name a temporary should still
	open."

	| source |
	source := [ aCompiledMethod getSourceFromFile ] on: Error do: [ :e | nil ].
	(source isNil or: [ source isEmpty ]) ifTrue: [ ^ nil ].

	^ [
	  | compiler |
	  compiler := OpalCompiler new.
	  compiler class: aClass.
	  compiler source: source.
	  compiler options: (self compilerOptionsWith: #( + optionSkipSemanticWarnings )).
	  compiler parse.
	  compiler doSemanticAnalysis ]
		  on: Error
		  do: [ :e | nil ]
