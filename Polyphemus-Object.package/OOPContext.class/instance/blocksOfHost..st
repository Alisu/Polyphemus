highlighting
blocksOfHost: aCompiledCode

	"Every compiled block of this code and of its blocks, outermost first, in literal order
	-- the same walk as #allCompiledBlocks does over the file. The last literal of a block
	is the code it is installed in, so following it walks back out to the method and in
	again forever."

	| blocks literals |
	blocks := OrderedCollection new.
	literals := aCompiledCode literals.
	aCompiledCode isCompiledBlock ifTrue: [ literals := literals allButLast ].
	literals do: [ :each |
		each isCompiledBlock ifTrue: [
			blocks add: each.
			blocks addAll: (self blocksOfHost: each) ] ].
	^ blocks
