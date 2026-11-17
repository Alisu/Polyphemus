running
resultOf: aToolName with: someArguments

	"What the server answers to a call of that tool: its result, an error result included."

	^ (self answer: (self
			    request: 'tools/call'
			    id: 9
			    params: (Dictionary new
					     at: 'name' put: aToolName;
					     at: 'arguments' put: someArguments;
					     yourself))) at: 'result'