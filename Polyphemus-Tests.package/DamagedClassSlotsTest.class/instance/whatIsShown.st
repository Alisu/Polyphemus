running
whatIsShown

	"What the tools show of the class, of its instance and of the context running in it."

	| instance |
	instance := context receiver.
	^ {
		  ('the class printed' -> [ subject printString ]).
		  ('oopName' -> [ subject oopName ]).
		  ('hasAReadableName' -> [ subject hasAReadableName ]).
		  ('its instance printed' -> [ instance printString ]).
		  ('its instance inspected' -> [ instance inspectionItems ]).
		  ('descriptionOfContext:' -> [ reifiedMemory descriptionOfContext: context ]).
		  ('highlightRangeOf:active:' -> [ reifiedMemory highlightRangeOf: context active: false ]).
		  ('tempNamesOf:' -> [ reifiedMemory tempNamesOf: context ]).
		  ('sourceNodeExecuted' -> [ context sourceNodeExecuted ]).
		  ('processStates' -> [ reifiedMemory processStates ]).
		  ('processInconsistencies' -> [ reifiedMemory processInconsistencies ]).
		  ('stackDescriptionOfProcess:' -> [ reifiedMemory stacks stackDescriptionOfProcess: process ]) }
