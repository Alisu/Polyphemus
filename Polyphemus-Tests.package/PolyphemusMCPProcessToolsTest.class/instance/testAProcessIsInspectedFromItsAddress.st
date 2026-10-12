tests
testAProcessIsInspectedFromItsAddress

	| inspection names |
	inspection := self inspect: (self namedProcess at: 'address') in: self resource target.
	self deny: (inspection at: 'isError').
	self assert: (((inspection at: 'structuredContent') at: 'class') endsWith: 'Process').
	names := ((inspection at: 'structuredContent') at: 'slots') collect: [ :each | each at: 'name' ].
	self assert: (names includesAll: #( 'suspendedContext' 'priority' 'name' ))
