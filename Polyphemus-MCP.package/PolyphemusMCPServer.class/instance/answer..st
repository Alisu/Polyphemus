serving
answer: aLine

	"The answer to one message, as a line of JSON, or nil for a notification. An error that is no
	refusal is said as an internal error, and the next line is served (#180)."

	| message id params |
	message := [ STONJSON fromString: aLine ]
		           on: Error
		           do: [ :e | ^ self errorLine: 'Parse error: ' , e messageText asString code: -32700 id: nil ].
	(message isDictionary and: [ message includesKey: 'method' ]) ifFalse: [
		^ self errorLine: 'Invalid request' code: -32600 id: nil ].
	(message includesKey: 'id') ifFalse: [ ^ nil ].
	id := message at: 'id'.
	params := message at: 'params' ifAbsent: [ Dictionary new ].
	params isDictionary ifFalse: [ ^ self errorLine: 'Invalid params: not an object' code: -32602 id: id ].
	^ [
	  [ self resultLine: (self respondTo: (message at: 'method') with: params) id: id ]
		  on: PolyphemusMCPError
		  do: [ :e | self errorLine: e messageText code: e code id: id ] ]
		  on: Error
		  do: [ :bug | self errorLine: 'Internal error: ' , bug class name , ' ' , bug messageText asString code: -32603 id: id ]
