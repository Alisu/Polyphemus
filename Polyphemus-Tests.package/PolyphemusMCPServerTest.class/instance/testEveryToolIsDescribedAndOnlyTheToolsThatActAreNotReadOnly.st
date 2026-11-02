tests
testEveryToolIsDescribedAndOnlyTheToolsThatActAreNotReadOnly

	"Clients show a tool that changes things differently, and may ask before it runs: the tools
	that act on a running VM say so, save that it replaces what let_go leaves (#128)."

	| tools acting |
	tools := ((self answer: (self request: 'tools/list' id: 2 params: Dictionary new)) at: 'result') at: 'tools'.
	self assert: ((tools collect: [ :each | each at: 'name' ]) includesAll: #( 'open_image' 'census' 'packages' 'hold' 'let_go' )).
	acting := #( 'hold' 'run_until' 'step' 'save' 'let_go' ).
	tools do: [ :each |
		self assert: (each at: 'description') notEmpty.
		self assert: ((each at: 'inputSchema') at: 'type') equals: 'object'.
		self
			assert: ((each at: 'annotations') at: 'readOnlyHint') = (acting includes: (each at: 'name')) not
			description: (each at: 'name').
		(acting includes: (each at: 'name')) ifTrue: [
			self
				assert: ((each at: 'annotations') at: 'destructiveHint') = ((each at: 'name') = 'save')
				description: (each at: 'name') , ' destructive' ] ]
