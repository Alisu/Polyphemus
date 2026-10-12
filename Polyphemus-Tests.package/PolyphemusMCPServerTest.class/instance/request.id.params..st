running
request: aMethod id: anId params: aDictionary

	^ Dictionary new
		  at: 'jsonrpc' put: '2.0';
		  at: 'id' put: anId;
		  at: 'method' put: aMethod;
		  at: 'params' put: aDictionary;
		  yourself
