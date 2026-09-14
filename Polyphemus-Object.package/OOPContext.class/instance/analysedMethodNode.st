context protocol
analysedMethodNode

	"This frame's method, parsed and analysed against the class it came from, so that the
	names in it mean what they meant over there.

	Only the front half of the compiler is used: parsing and semantic analysis. Code is
	deliberately not generated, because code generated here is not the code in the file:
	compiling this same source in this image produces different bytecodes, so a pc map
	taken from it would point at the wrong place.

	The source has to be the real source. A method whose source is gone decompiles to text
	whose temporaries are called tmp1 and arg1, and those are inventions of this image, not
	names anybody wrote.

	The answer is kept because it is not cheap -- around a second, most of it spent finding
	the source in the image's own sources file -- and because a debugger asks for it once
	per variable it shows. false is kept for 'tried, and there is nothing here', so that a
	frame without source is not analysed again and again.

	Answers nil rather than raising when the source cannot be read or understood: a
	debugger that cannot name a temporary should still open."

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
			          compiler parse.
			          compiler doSemanticAnalysis ]
				          on: Error
				          do: [ :e | nil ] ].

	analysedNode := result ifNil: [ false ].
	^ result
