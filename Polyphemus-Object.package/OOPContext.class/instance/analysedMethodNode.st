context protocol
analysedMethodNode

	"This frame's method, parsed and analysed against the class it came from, so that the
	names in it mean what they meant over there.

	Only the front half of the compiler is used: parsing and semantic analysis. Code is
	deliberately not generated, because code generated here is not the code in the file:
	compiling this same source in this image produces different bytecodes, so a pc map
	taken from it would point at the wrong place.

	Semantic warnings are turned off, which is the compiler's own switch for analysing code
	that is not this image's. Left on, a name the other image has and we cannot find is
	written into OUR Undeclared dictionary -- eleven of them from one snapshot, saved with
	the image, still there on the next run -- and every temporary is reported as shadowing
	the undeclared name that was just invented for it.

	The source has to be the real source. A method whose source is gone decompiles to text
	whose temporaries are called tmp1 and arg1, and those are inventions of this image, not
	names anybody wrote.

	The answer is kept: a debugger asks for it once per variable it shows, and false is kept
	for 'tried, and there is nothing here'.

	Answers nil rather than raising when the source cannot be read or understood: a debugger
	that cannot name a temporary should still open."

	| source result |
	analysedNode ifNotNil: [
		^ analysedNode == false
			  ifTrue: [ nil ]
			  ifFalse: [ analysedNode ] ].

	source := [ self homeMethod getSourceFromFile ] on: Error do: [ :e | nil ].
	result := (source isNil or: [ source isEmpty ])
		          ifTrue: [ nil ]
		          ifFalse: [
			          [
			          | compiler |
			          compiler := OpalCompiler new.
			          compiler class: self receiver oopClass.
			          compiler source: source.
			          compiler options: #( + optionSkipSemanticWarnings ).
			          compiler parse.
			          compiler doSemanticAnalysis ]
				          on: Error
				          do: [ :e | nil ] ].

	analysedNode := result ifNil: [ false ].
	^ result
