results
errorLine: aString code: anInteger id: anId

	^ STONJSON toString: (Dictionary new
			   at: 'jsonrpc' put: '2.0';
			   at: 'id' put: anId;
			   at: 'error' put: (Dictionary new at: 'code' put: anInteger; at: 'message' put: aString; yourself);
			   yourself)
