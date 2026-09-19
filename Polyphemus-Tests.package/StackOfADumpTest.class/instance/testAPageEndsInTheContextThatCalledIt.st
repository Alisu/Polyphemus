tests
testAPageEndsInTheContextThatCalledIt

	"The oldest frame of a page was called from a context, which Cog keeps on the first word
	of the page, above the frame's own context (CoInterpreter>>makeBaseFrameFor:). It is nil
	only for the first activation of a process."

	| bases |
	bases := self allFrames select: [ :each | each isBaseFrame ].

	self assert: bases notEmpty.
	bases do: [ :each |
		| caller |
		caller := each oopPageCaller.
		self assert: (caller isNilOop or: [ caller isContextOop ]).
		self deny: caller equals: each oopContext ]
