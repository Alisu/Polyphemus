tests
testEachToolIsAnsweredByTheMethodOfItsName

	"#118: the tools were named twice, in tools and in call:'s table, which could disagree."

	self server tools do: [ :each |
		self assert: (self server respondsTo: (self server selectorOfTool: (each at: 'name'))) ].
	self assert: (self server selectorOfTool: 'where_stuck') equals: #whereStuck:.
	self assert: (self server selectorOfTool: 'format_disk') isNil
