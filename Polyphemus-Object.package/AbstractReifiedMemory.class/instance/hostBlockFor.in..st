highlighting
hostBlockFor: anActivation in: aHostMethod

	"The block of aHostMethod in the position of the block this activation runs, if both
	methods have as many blocks. Nothing more is checked here."

	| blocks hostBlocks index code |
	code := [ anActivation compiledCode ] on: Error do: [ :e | nil ].
	code ifNil: [ ^ nil ].
	blocks := [ anActivation homeMethod allCompiledBlocks ] on: Error do: [ :e | #(  ) ].
	index := blocks indexOf: code.
	index isZero ifTrue: [ ^ nil ].
	hostBlocks := self blocksOfHost: aHostMethod.
	hostBlocks size = blocks size ifFalse: [ ^ nil ].
	^ hostBlocks at: index
