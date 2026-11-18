protocol
call: someParams

	"An unknown tool is the client's error; a tool that refuses says so in its result. Any other
	error is a bug of ours, and the server's to say (answer:), not the tool's refusal (#180)."

	| name arguments selector |
	name := someParams at: 'name' ifAbsent: [ nil ].
	arguments := someParams at: 'arguments' ifAbsent: [ Dictionary new ].
	arguments isDictionary ifFalse: [
		^ PolyphemusMCPError signal: 'Invalid params: the arguments of ' , name printString , ' are not an object' code: -32602 ].
	selector := (self selectorOfTool: name) ifNil: [
		            ^ PolyphemusMCPError signal: 'Unknown tool: ' , name printString code: -32602 ].
	^ [ self perform: selector with: arguments ]
		  on: PolyphemusError , FileSystemError
		  do: [ :refusal | self failure: refusal messageText asString ]
