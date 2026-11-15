running
whatIsShown

	"What the tools show of the block, of the method around it and of the context running it."

	^ {
		  ('the block printed' -> [ subject printString ]).
		  ('methodClass' -> [ subject methodClass ]).
		  ('sourceNodeForPC:' -> [ subject sourceNodeForPC: 3 ]).
		  ('the block inspected' -> [ subject inspectionItems ]).
		  ('descriptionOfContext:' -> [ reifiedMemory descriptionOfContext: context ]).
		  ('sourceOfContext:' -> [ reifiedMemory stacks sourceOfContext: context ]).
		  ('disassemblyOfContext:' -> [ reifiedMemory stacks disassemblyOfContext: context ]).
		  ('highlightRangeOf:active:' -> [ reifiedMemory highlightRangeOf: context active: false ]).
		  ('tempNamesOf:' -> [ reifiedMemory tempNamesOf: context ]).
		  ('sourceNodeExecuted' -> [ context sourceNodeExecuted ]).
		  ('the context printed' -> [ context printString ]).
		  ('the stack described' -> [ reifiedMemory stacks stackDescriptionOfProcess: process ]).
		  ('contextInconsistencies' -> [ reifiedMemory stacks contextInconsistencies ]) }
