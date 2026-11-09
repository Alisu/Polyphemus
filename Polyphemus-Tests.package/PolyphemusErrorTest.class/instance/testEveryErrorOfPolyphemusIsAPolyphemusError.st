tests
testEveryErrorOfPolyphemusIsAPolyphemusError

	"#118: a caller can then catch Polyphemus's errors, and let a bug of its own (a
	MessageNotUnderstood, a ZeroDivide) through, rather than catching every Error."

	| ours |
	ours := Error allSubclasses select: [ :each |
		        (each package name beginsWith: 'Polyphemus-') and: [ (each package name includesSubstring: 'Tests') not ] ].
	self assert: ours notEmpty.
	self
		assert: (ours reject: [ :each | each includesBehavior: (Smalltalk globals at: #PolyphemusError) ]) asArray
		equals: #(  )
