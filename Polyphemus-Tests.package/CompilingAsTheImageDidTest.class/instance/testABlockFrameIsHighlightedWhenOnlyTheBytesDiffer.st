tests
testABlockFrameIsHighlightedWhenOnlyTheBytesDiffer

	"#4, for a block: bytes laid out differently, same sends, same highlight."

	| exact memory frame compiler tree expected |
	exact := self memory.
	expected := exact
		            highlightRangeOf: (self frameOf: exact described: self blockFrameUsingInstanceVariables)
		            active: false.

	memory := self memory forgetWhatWasRead; yourself.
	frame := self frameOf: memory described: self blockFrameUsingInstanceVariables.
	compiler := OpalCompiler new
		            class: frame receiver oopClass;
		            source: frame homeMethod getSourceFromFile;
		            options: (memory compilerOptionsWith:
					             #( + optionSkipSemanticWarnings + optionEmbeddSources ))
				             , #( + optionLongIvarAccessBytecodes );
		            yourself.
	tree := compiler parse.
	compiler doSemanticAnalysis.
	memory
		rememberedAt: 'hostCompilation.' , frame homeMethod address printString
		ifAbsentPut: [ Array with: tree generateWithSource with: tree ].

	self assert: (memory faithfulCodeOf: frame) isNil.
	self deny: expected isEmpty.
	self assert: (memory highlightRangeOf: frame active: false) equals: expected
