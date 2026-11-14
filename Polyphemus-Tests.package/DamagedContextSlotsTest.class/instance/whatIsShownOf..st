running
whatIsShownOf: aContext

	"What the tools show of an activation, its stack and the reading, each named: these answer,
	whatever the damage."

	| stacks |
	stacks := reifiedMemory stacks.
	^ {
		  ('contextsOfProcess:' -> [ stacks contextsOfProcess: process ]).
		  ('activationsOfProcess:' -> [ stacks activationsOfProcess: process ]).
		  ('contextsFrom:' -> [ stacks contextsFrom: aContext ]).
		  ('stackFrom:ofSize:' -> [ stacks stackFrom: aContext ofSize: 30 ]).
		  ('descriptionOfContext:' -> [ stacks descriptionOfContext: aContext ]).
		  ('sourceOfContext:' -> [ stacks sourceOfContext: aContext ]).
		  ('disassemblyOfContext:' -> [ stacks disassemblyOfContext: aContext ]).
		  ('contextInconsistencies' -> [ stacks contextInconsistencies ]).
		  ('marriedContexts' -> [ stacks marriedContexts ]).
		  ('stackDescriptionOfProcess:' -> [ stacks stackDescriptionOfProcess: process ]).
		  ('isMarriedContext:' -> [ stacks isMarriedContext: aContext ]).
		  ('highlightRangeOf:active: false' -> [ reifiedMemory highlightRangeOf: aContext active: false ]).
		  ('highlightRangeOf:active: true' -> [ reifiedMemory highlightRangeOf: aContext active: true ]).
		  ('tempNamesOf:' -> [ reifiedMemory tempNamesOf: aContext ]).
		  ('processStates' -> [ reifiedMemory processStates ]).
		  ('processInconsistencies' -> [ reifiedMemory processInconsistencies ]) }
	  , (#( #selector #startpc #endPC #sourceCode #tempNames #printString ) collect: [ :each |
			   each -> [ aContext perform: each ] ])
