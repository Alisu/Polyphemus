highlighting
blocksOfHost: aCompiledCode

	"Every compiled block of this code and of its blocks, outermost first, in literal order
	-- the same walk as #allCompiledBlocks does over the file.

	The last literal of a block is the code it is installed in, so following it walks back
	out to the method and in again forever; it is dropped. A block with no literals at all
	has nothing to drop, and asking for all but the last of nothing is an error rather than
	an empty answer."

	| blocks literals |
	blocks := OrderedCollection new.
	literals := [ aCompiledCode literals ] on: Error do: [ :e | #(  ) ].
	(aCompiledCode isCompiledBlock and: [ literals isEmpty not ]) ifTrue: [
		literals := literals allButLast ].
	literals do: [ :each |
		([ each isCompiledBlock ] on: Error do: [ :e | false ]) ifTrue: [
			blocks add: each.
			blocks addAll: (self blocksOfHost: each) ] ].
	^ blocks
