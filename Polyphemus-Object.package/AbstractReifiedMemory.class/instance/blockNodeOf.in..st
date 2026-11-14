naming
blockNodeOf: anActivation in: aMethodNode

	"The block node of the source this activation runs, matched by order once inlined blocks
	are dropped. nil unless block counts and argument counts agree."

	| nodes blocks index code |
	code := [ anActivation compiledCode ] on: PolyphemusError do: [ :e | nil ].
	code ifNil: [ ^ nil ].
	blocks := [ anActivation homeMethod allCompiledBlocks ] on: PolyphemusError do: [ :e | #(  ) ].
	index := blocks indexOf: code.
	index isZero ifTrue: [ ^ nil ].

	nodes := aMethodNode blockNodes reject: [ :each |
		         each scope class name = #OCOptimizedBlockScope ].
	nodes size = blocks size ifFalse: [ ^ nil ].

	^ ([ (nodes at: index) arguments size = code numArgs ]
		   on: PolyphemusError
		   do: [ :e | false ])
		  ifTrue: [ nodes at: index ]
		  ifFalse: [ nil ]
