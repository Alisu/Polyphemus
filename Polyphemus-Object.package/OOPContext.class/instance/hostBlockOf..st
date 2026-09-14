highlighting
hostBlockOf: aHostMethod

	"The block of the freshly compiled method that answers to the block this frame is
	running. Lined up by order, the way the source's block nodes are, and then checked:
	the two must agree on how many blocks there are and on the block's own bytecodes."

	| blocks hostBlocks index |
	blocks := [ self homeMethod allCompiledBlocks ] on: Error do: [ :e | #(  ) ].
	index := blocks indexOf: self compiledCode.
	index isZero ifTrue: [ ^ nil ].

	hostBlocks := self blocksOfHost: aHostMethod.
	hostBlocks size = blocks size ifFalse: [ ^ nil ].

	^ (self code: (hostBlocks at: index) matches: self compiledCode)
		  ifTrue: [ hostBlocks at: index ]
		  ifFalse: [ nil ]
