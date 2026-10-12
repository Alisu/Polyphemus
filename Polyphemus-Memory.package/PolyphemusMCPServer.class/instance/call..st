protocol
call: someParams

	"An unknown tool is the client's error; a tool that fails says so in its result."

	| name arguments selector |
	name := someParams at: 'name' ifAbsent: [ nil ].
	arguments := someParams at: 'arguments' ifAbsent: [ Dictionary new ].
	selector := {
		            ('open_image' -> #openImage:).
		            ('census' -> #census:).
		            ('packages' -> #packages:).
		            ('open_core' -> #openCore:).
		            ('processes' -> #processes:).
		            ('stack' -> #stack:).
		            ('inspect' -> #inspect:).
		            ('where_stuck' -> #whereStuck:).
		            ('open_process' -> #openProcess:) } asDictionary
		            at: name
		            ifAbsent: [ ^ PolyphemusMCPError signal: 'Unknown tool: ' , name printString code: -32602 ].
	^ [ self perform: selector with: arguments ]
		  on: Error
		  do: [ :e | self failure: e messageText asString ]
