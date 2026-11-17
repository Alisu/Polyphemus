serving
answer: aLine

	"The answer to one message, as a line of JSON, or nil for a notification."

	| message id |
	message := [ STONJSON fromString: aLine ]
		           on: Error
		           do: [ :e | ^ self errorLine: 'Parse error: ' , e messageText asString code: -32700 id: nil ].
	(message isDictionary and: [ message includesKey: 'method' ]) ifFalse: [
		^ self errorLine: 'Invalid request' code: -32600 id: nil ].
	(message includesKey: 'id') ifFalse: [ ^ nil ].
	id := message at: 'id'.
	^ [
	  self resultLine: (self respondTo: (message at: 'method') with: (message at: 'params' ifAbsent: [ Dictionary new ])) id: id ]
		  on: PolyphemusMCPError
		  do: [ :e | self errorLine: e messageText code: e code id: id ]
