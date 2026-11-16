running
callOn: aServer tool: aToolName with: aDictionary

	"What a server of this test's own answers that tool, asked as a client asks."

	^ (STONJSON fromString: (aServer answer: (STONJSON toString: (Dictionary new
				      at: 'jsonrpc' put: '2.0';
				      at: 'id' put: 1;
				      at: 'method' put: 'tools/call';
				      at: 'params' put: (Dictionary new
						       at: 'name' put: aToolName;
						       at: 'arguments' put: aDictionary;
						       yourself);
				      yourself)))) at: 'result'
