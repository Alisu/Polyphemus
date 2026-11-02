helpers
call: aToolName with: someArguments on: aServer

	"The result of that tool, as a client reads it; a failure says why."

	| result |
	result := self answerOf: aToolName with: someArguments on: aServer.
	self deny: (result at: 'isError') description: [ aToolName , ': ' , ((result at: 'content') first at: 'text') ].
	^ result at: 'structuredContent'
