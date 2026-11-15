naming
analyseMethodOf: aCompiledMethod against: aClass

	"Parse and analyse, or answer nil: a debugger that cannot name a temporary should still
	open."

	| source options |
	source := [ aCompiledMethod getSourceFromFile ] on: PolyphemusError do: [ :e | nil ].
	(source isNil or: [ source isEmpty ]) ifTrue: [ ^ nil ].

	options := self compilerOptionsWith: #( + optionSkipSemanticWarnings ).
	^ ForeignCode
		  askingPharo: [
			  | compiler |
			  compiler := OpalCompiler new.
			  compiler class: aClass.
			  compiler source: source.
			  compiler options: options.
			  compiler parse.
			  compiler doSemanticAnalysis ]
		  ifItFails: [ nil ]
