serving
respondTo: aMethod with: someParams

	aMethod = 'initialize' ifTrue: [ ^ self initialize: someParams ].
	aMethod = 'ping' ifTrue: [ ^ Dictionary new ].
	aMethod = 'tools/list' ifTrue: [ ^ Dictionary new at: 'tools' put: self tools; yourself ].
	aMethod = 'tools/call' ifTrue: [ ^ self call: someParams ].
	^ PolyphemusMCPError signal: 'Method not found: ' , aMethod printString code: -32601
