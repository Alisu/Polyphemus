tests
testEveryToolIsReadOnlyAndDescribed

	"This slice reads, and says so: clients show a tool that changes things differently."

	| tools |
	tools := ((self answer: (self request: 'tools/list' id: 2 params: Dictionary new)) at: 'result') at: 'tools'.
	self assert: ((tools collect: [ :each | each at: 'name' ]) includesAll: #( 'open_image' 'census' 'packages' )).
	tools do: [ :each |
		self assert: (each at: 'description') notEmpty.
		self assert: ((each at: 'inputSchema') at: 'type') equals: 'object'.
		self assert: ((each at: 'annotations') at: 'readOnlyHint') ]
