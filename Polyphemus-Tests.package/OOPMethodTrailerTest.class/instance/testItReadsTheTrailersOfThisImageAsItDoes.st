tests
testItReadsTheTrailersOfThisImageAsItDoes

	"On this host's own methods, the decoder for its format answers what the host itself does."

	((Object methods , OrderedCollection methods , String methods) first: 300) do: [ :each |
		| ours |
		(CompiledMethod class canUnderstand: #trailerSize)
			ifTrue: [
				ours := OOPFixedMethodTrailer on: each.
				self assert: ours size equals: 5.
				self assert: ours sourcePointer equals: each sourcePointer ]
			ifFalse: [
				| theirs |
				ours := OOPVariableMethodTrailer on: each.
				theirs := (Smalltalk at: #CompiledMethodTrailer) new method: each.
				self assert: ours size equals: theirs size.
				self assert: ours sourcePointer equals: theirs sourcePointer.
				self assert: ours hasSourcePointer equals: theirs hasSourcePointer.
				self assert: ours sourceCode equals: theirs sourceCode ].
		ours hasSourcePointer ifTrue: [
			self
				assert: ours sourceFileIndex
				equals: (SourceFiles fileIndexFromSourcePointer: ours sourcePointer).
			self
				assert: ours sourceFilePosition
				equals: (SourceFiles filePositionFromSourcePointer: ours sourcePointer) ] ]
