naming
blockNodeOf: anActivation in: aMethodNode

	"Which block of the source is this activation running? The file holds a compiled block
	and the source holds block nodes, and neither points at the other.

	They can still be lined up. Blocks the compiler inlines -- ifTrue:, and:, whileTrue:,
	to:do: -- produce no compiled block, and no activation either, so dropping them leaves
	the compiled blocks of a method in the same order as the block nodes of its source.

	The order is only believed when the file agrees with it: as many compiled blocks as
	block nodes, and the block found taking the same number of arguments as the one running.
	When they disagree, no scope is answered rather than the wrong one."

	| nodes blocks index code |
	code := [ anActivation compiledCode ] on: Error do: [ :e | nil ].
	code ifNil: [ ^ nil ].
	blocks := [ anActivation homeMethod allCompiledBlocks ] on: Error do: [ :e | #(  ) ].
	index := blocks indexOf: code.
	index isZero ifTrue: [ ^ nil ].

	nodes := aMethodNode blockNodes reject: [ :each |
		         each scope class name = #OCOptimizedBlockScope ].
	nodes size = blocks size ifFalse: [ ^ nil ].

	^ ([ (nodes at: index) arguments size = code numArgs ]
		   on: Error
		   do: [ :e | false ])
		  ifTrue: [ nodes at: index ]
		  ifFalse: [ nil ]
