running
questionsOf: aContext

	"What a stack, a context and the reading are asked about an activation, each named."

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
	  , (#( #sender #pc #stackp #compiledCode #homeMethod #selector #startpc #endPC #isBlockContext
		     #isDead #receiver #closureOrNil #outerContext #home #method #methodClass #sourceCode
		     #tempNames #printString ) collect: [ :each | each -> [ aContext perform: each ] ])
