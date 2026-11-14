running
rememberCodeOfOtherBytesFor: aFrame in: aMemory

	"Plants, as compiled here, the frame's method with long instance variable access: other bytes,
	the same sends."

	| compiler tree |
	compiler := OpalCompiler new
		            class: aFrame receiver oopClass;
		            source: aFrame homeMethod getSourceFromFile;
		            options: (aMemory compilerOptionsWith:
					             #( + optionSkipSemanticWarnings + optionEmbeddSources ))
				             , #( + optionLongIvarAccessBytecodes );
		            yourself.
	tree := compiler parse.
	compiler doSemanticAnalysis.
	aMemory
		rememberedAt: 'hostCompilation.' , aFrame homeMethod address printString
		ifAbsentPut: [ Array with: tree generateWithSource with: tree ]
