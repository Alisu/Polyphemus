tools
step: someArguments

	"Step the held process into, over or through the frame it is at, or the one below, as the
	debugger's buttons do; answers its frames afterwards."

	| session how frame context |
	session := self sessionAt: someArguments.
	how := someArguments at: 'how' ifAbsent: [ 'over' ].
	frame := someArguments at: 'frame' ifAbsent: [ 1 ].
	context := session interruptedContext.
	frame - 1 timesRepeat: [ context := context ifNotNil: [ context sender ] ].
	context ifNil: [ self error: 'No frame ' , frame printString , ' in the held process' ].
	session
		perform: ({ 'into' -> #stepInto:. 'over' -> #stepOver:. 'through' -> #stepThrough: } asDictionary
				 at: how
				 ifAbsent: [ self error: 'step how: into, over or through, not ' , how printString ])
		with: context.
	^ self held: (someArguments at: 'handle') saying: 'Stepped ' , how , '.'
