tools
whereStuck: someArguments

	| pid report |
	pid := someArguments at: 'pid' ifAbsent: [ self error: 'where_stuck needs a pid' ].
	report := [ Polyphemus whereIsStuck: pid ]
		          on: Error
		          do: [ :e | self error: 'Cannot look at process ' , pid printString , ': ' , e messageText asString ].
	^ self
		  text: report printString
		  structured: (Dictionary new
				   at: 'pid' put: pid;
				   at: 'summary' put: report mainThread summary;
				   at: 'threads' put: (report threads collect: [ :each | report descriptionOf: each ]) asArray;
				   at: 'catches' put: report caughtSignals asArray;
				   at: 'stoppedToLook' put: report stoppedToLook;
				   yourself)
