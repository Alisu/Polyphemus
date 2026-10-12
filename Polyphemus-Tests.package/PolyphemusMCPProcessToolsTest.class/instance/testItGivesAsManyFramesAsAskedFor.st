tests
testItGivesAsManyFramesAsAskedFor

	| deep result |
	deep := (self processesOf: self resource target) detect: [ :each | (each at: 'depth') > 3 ].
	result := (self call: 'stack' with: (Dictionary new
				    at: 'handle' put: self resource target;
				    at: 'process' put: (deep at: 'process');
				    at: 'depth' put: 2;
				    yourself)) at: 'structuredContent'.
	self assert: (result at: 'frames') size equals: 2.
	self assert: (result at: 'depth') equals: (deep at: 'depth')
