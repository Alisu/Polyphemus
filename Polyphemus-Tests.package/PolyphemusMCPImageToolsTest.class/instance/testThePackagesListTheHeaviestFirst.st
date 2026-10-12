tests
testThePackagesListTheHeaviestFirst

	"Kernel owns the most in the pinned Pharo 10 image (0.73 MB, #69)."

	| rows |
	rows := ((self call: 'packages' with: (Dictionary new at: 'top' put: 3; yourself)) at: 'structuredContent') at: 'packages'.
	self assert: rows size equals: 3.
	self assert: (rows first at: 'name') equals: 'Kernel'
