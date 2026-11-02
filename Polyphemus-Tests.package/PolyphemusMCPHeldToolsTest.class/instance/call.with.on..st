helpers
call: aToolName with: someArguments on: aServer

	"The result of that tool, as a client reads it; a failure says why."

	| result |
	result := (STONJSON fromString: (aServer answer: (STONJSON toString: (Dictionary new
				      at: 'jsonrpc' put: '2.0';
				      at: 'id' put: 1;
				      at: 'method' put: 'tools/call';
				      at: 'params' put: (Dictionary new at: 'name' put: aToolName; at: 'arguments' put: someArguments; yourself);
				      yourself)))) at: 'result'.
	self deny: (result at: 'isError') description: [ aToolName , ': ' , ((result at: 'content') first at: 'text') ].
	^ result at: 'structuredContent'
