tests
testACallWithoutItsParametersIsAnErrorAndTheNextLineIsServed

	"#180: params that are no object, or arguments that are none, failed outside any handler and
	ended the server, the images it held left held."

	| in out lines |
	in := ReadStream on: (String lf join: {
				        '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":[]}'.
				        '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":null}'.
				        '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"census","arguments":[]}}'.
				        '{"jsonrpc":"2.0","id":4,"method":"initialize","params":7}'.
				        (STONJSON toString: (self request: 'ping' id: 5 params: Dictionary new)) }).
	out := WriteStream on: String new.
	self server serveFrom: in to: out.
	lines := out contents lines collect: [ :each | STONJSON fromString: each ].
	self assert: (lines collect: [ :each | each at: 'id' ]) asArray equals: #( 1 2 3 4 5 ).
	(lines first: 4) do: [ :each | self assert: ((each at: 'error') at: 'code') equals: -32602 ].
	self assert: (lines last includesKey: 'result')