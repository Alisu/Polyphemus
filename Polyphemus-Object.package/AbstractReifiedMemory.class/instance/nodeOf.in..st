highlighting
nodeOf: aHostCode in: aTree

	"The node of aTree that aHostCode was compiled from: the tree itself for the method, and
	for a block the node at the pc where its outer code creates it -- Pharo's own route."

	aHostCode isCompiledBlock ifFalse: [ ^ aTree ].
	^ (self nodeOf: aHostCode outerCode in: aTree) sourceNodeForPC: aHostCode pcInOuter
