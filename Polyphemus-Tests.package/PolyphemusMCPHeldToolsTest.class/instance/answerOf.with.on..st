helpers
answerOf: aToolName with: someArguments on: aServer

	"The result of that tool, as a client reads it, failed or not."

	^ (STONJSON fromString: (aServer answer: (STONJSON toString: (Dictionary new
				      at: 'jsonrpc' put: '2.0';
				      at: 'id' put: 1;
				      at: 'method' put: 'tools/call';
				      at: 'params' put: (Dictionary new at: 'name' put: aToolName; at: 'arguments' put: someArguments; yourself);
				      yourself)))) at: 'result'
