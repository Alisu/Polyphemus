tools
runUntil: someArguments

	"Let the held image run until some process reaches the method, and hold it there; if it is not
	reached in time, it is held where it got to. Answers which, and the frames."

	| session method reached answer |
	session := self sessionAt: someArguments.
	method := someArguments at: 'method' ifAbsent: [ self error: 'run_until needs a method, as Class >> #selector' ].
	reached := session runUntil: method within: (someArguments at: 'seconds' ifAbsent: [ 60 ]) seconds.
	answer := self held: (someArguments at: 'handle') saying: (reached
			           ifTrue: [ 'Reached ' , method , ', and held there.' ]
			           ifFalse: [ method , ' was not reached in time: held where it got to.' ]).
	(answer at: 'structuredContent') at: 'reached' put: reached.
	^ answer
