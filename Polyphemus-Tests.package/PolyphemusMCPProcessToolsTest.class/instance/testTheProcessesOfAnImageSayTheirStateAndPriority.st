tests
testTheProcessesOfAnImageSayTheirStateAndPriority

	| rows |
	rows := self processesOf: self resource target.
	self assert: rows size > 3.
	rows do: [ :each |
		self assert: ((each at: 'priority') between: 1 and: 100).
		self assert: (each at: 'state') notEmpty.
		self assert: (each at: 'depth') >= 0 ].
	self assert: (rows anySatisfy: [ :each | (each at: 'priority') = 40 ])
