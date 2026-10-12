running
call: aToolName with: aDictionary

	| resource |
	resource := PolyphemusMCPServerResource current.
	^ (STONJSON fromString: (resource server answer: (STONJSON toString: (Dictionary new
				      at: 'jsonrpc' put: '2.0';
				      at: 'id' put: 9;
				      at: 'method' put: 'tools/call';
				      at: 'params' put: (Dictionary new
						       at: 'name' put: aToolName;
						       at: 'arguments' put: (aDictionary copy at: 'handle' put: resource handle; yourself);
						       yourself);
				      yourself)))) at: 'result'
