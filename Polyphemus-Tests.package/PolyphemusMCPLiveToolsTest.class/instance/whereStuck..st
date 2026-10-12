running
whereStuck: aPid

	^ (STONJSON fromString: (PolyphemusMCPServer new answer: (STONJSON toString: (Dictionary new
				      at: 'jsonrpc' put: '2.0';
				      at: 'id' put: 1;
				      at: 'method' put: 'tools/call';
				      at: 'params' put: (Dictionary new
						       at: 'name' put: 'where_stuck';
						       at: 'arguments' put: (Dictionary new at: 'pid' put: aPid; yourself);
						       yourself);
				      yourself)))) at: 'result'
