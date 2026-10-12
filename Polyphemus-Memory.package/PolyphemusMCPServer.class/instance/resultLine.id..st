results
resultLine: aResult id: anId

	^ STONJSON toString: (Dictionary new
			   at: 'jsonrpc' put: '2.0';
			   at: 'id' put: anId;
			   at: 'result' put: aResult;
			   yourself)
