tests
testOpeningAFileThatIsNotThereSaysSo

	| result |
	result := (STONJSON fromString: (PolyphemusMCPServer new answer: (STONJSON toString: (Dictionary new
				             at: 'jsonrpc' put: '2.0';
				             at: 'id' put: 1;
				             at: 'method' put: 'tools/call';
				             at: 'params' put: (Dictionary new
						              at: 'name' put: 'open_image';
						              at: 'arguments' put: (Dictionary new at: 'path' put: '/nowhere/missing.image'; yourself);
						              yourself);
				             yourself)))) at: 'result'.
	self assert: (result at: 'isError').
	self assert: ((self textOf: result) includesSubstring: '/nowhere/missing.image')
