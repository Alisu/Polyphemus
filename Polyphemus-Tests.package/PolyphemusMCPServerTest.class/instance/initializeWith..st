running
initializeWith: aVersion

	^ self answer: (self request: 'initialize' id: 1 params: (Dictionary new
				    at: 'protocolVersion' put: aVersion;
				    at: 'capabilities' put: Dictionary new;
				    at: 'clientInfo' put: (Dictionary new at: 'name' put: 'test'; at: 'version' put: '0'; yourself);
				    yourself))
