tests
testAFrameIsHighlightedWhenOnlyTheBytesDiffer

	"#4. A host compiler that lays bytes out differently but makes the same sends -- here,
	long instance variable access, in a method making seven sends -- must still place the
	highlight on the same send."

	| exact memory frame source compiler tree differing expected |
	exact := Polyphemus readImageFile: PharoImageAccessor pathToPharo10.
	expected := exact
		            highlightRangeOf: (self frameOf: exact described: 'DelaySemaphoreScheduler>>suspendAtTimingPriority')
		            active: false.

	memory := Polyphemus readImageFile: PharoImageAccessor pathToPharo10.
	frame := self frameOf: memory described: 'DelaySemaphoreScheduler>>suspendAtTimingPriority'.
	source := frame homeMethod getSourceFromFile.
	compiler := OpalCompiler new
		            class: frame receiver oopClass;
		            source: source;
		            options: (memory compilerOptionsWith:
					             #( + optionSkipSemanticWarnings + optionEmbeddSources ))
				             , #( + optionLongIvarAccessBytecodes );
		            yourself.
	tree := compiler parse.
	compiler doSemanticAnalysis.
	differing := tree generateWithSource.
	memory
		rememberedAt: 'hostCompilation.' , frame homeMethod address printString
		ifAbsentPut: [ Array with: differing with: tree ].

	self assert: (memory faithfulCodeOf: frame) isNil.
	self deny: expected isEmpty.
	self assert: (memory highlightRangeOf: frame active: false) equals: expected
