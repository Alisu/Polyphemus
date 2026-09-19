naming
blockNodeOf: anActivation in: aMethodNode

	"The block node of the source this activation runs, matched by order once inlined blocks
	are dropped. nil unless block counts and argument counts agree."

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
