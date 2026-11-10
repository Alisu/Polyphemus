tools
step: someArguments

	"Step the held process into, over or through the frame it is at, or the one below, as the
	debugger's buttons do; answers its frames afterwards."

	| session how |
	session := self sessionAt: someArguments.
	how := someArguments at: 'how' ifAbsent: [ 'over' ].
	session
		perform: ({ 'into' -> #stepInto:. 'over' -> #stepOver:. 'through' -> #stepThrough: } asDictionary
				 at: how
				 ifAbsent: [ ToolCallFailed signal: 'step how: into, over or through, not ' , how printString ])
		with: (self frame: (someArguments at: 'frame' ifAbsent: [ 1 ]) of: session).
	^ self held: (someArguments at: 'handle') saying: 'Stepped ' , how , '.'
