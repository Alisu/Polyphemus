tests
testItListsTheSendsInTheOrderTheyRun

	| code |
	code := self compile: 'foo ^ x + (self bar: y)' options: #(  ).

	self assert: (SendSequence of: code) selectors asArray equals: #( 'bar:' '+' )
