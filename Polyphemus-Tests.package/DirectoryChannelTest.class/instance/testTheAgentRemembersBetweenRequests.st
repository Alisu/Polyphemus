tests
testTheAgentRemembersBetweenRequests

	"Each request runs with the agent's workspace as self, so a step can find what the request
	before it set up."

	channel ask: 'self at: #kept put: 42'.
	self assert: (channel ask: 'self at: #kept') equals: '42'
