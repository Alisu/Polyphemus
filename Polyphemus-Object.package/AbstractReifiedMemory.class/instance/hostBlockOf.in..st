highlighting
hostBlockOf: anActivation in: aHostMethod

	"The block of the freshly compiled method that answers to the block this activation is
	running. Lined up by order, the way the source's block nodes are, and then checked: the
	two must agree on how many blocks there are and on the block's own bytecodes."

	| blocks hostBlocks index code |
	code := [ anActivation compiledCode ] on: Error do: [ :e | nil ].
	code ifNil: [ ^ nil ].
	blocks := [ anActivation homeMethod allCompiledBlocks ] on: Error do: [ :e | #(  ) ].
	index := blocks indexOf: code.
	index isZero ifTrue: [ ^ nil ].

	hostBlocks := self blocksOfHost: aHostMethod.
	hostBlocks size = blocks size ifFalse: [ ^ nil ].

	^ (self host: (hostBlocks at: index) matchesOop: code)
		  ifTrue: [ hostBlocks at: index ]
		  ifFalse: [ nil ]
