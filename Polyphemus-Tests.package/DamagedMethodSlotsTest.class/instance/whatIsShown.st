running
whatIsShown

	"What the tools show of the method and of the context running it."

	^ {
		  ('the method printed' -> [ subject printString ]).
		  ('selector' -> [ subject selector ]).
		  ('methodClass' -> [ subject methodClass ]).
		  ('argumentNames' -> [ subject argumentNames ]).
		  ('propertyAt:ifAbsent:' -> [ subject propertyAt: #noSuchProperty ifAbsent: [ nil ] ]).
		  ('sourceNodeForPC:' -> [ subject sourceNodeForPC: 60 ]).
		  ('the method inspected' -> [ subject inspectionItems ]).
		  ('the method in its image' -> [ subject inImageText ]).
		  ('descriptionOfContext:' -> [ reifiedMemory descriptionOfContext: context ]).
		  ('sourceOfContext:' -> [ reifiedMemory stacks sourceOfContext: context ]).
		  ('disassemblyOfContext:' -> [ reifiedMemory stacks disassemblyOfContext: context ]).
		  ('highlightRangeOf:active:' -> [ reifiedMemory highlightRangeOf: context active: false ]).
		  ('tempNamesOf:' -> [ reifiedMemory tempNamesOf: context ]).
		  ('sourceNodeExecuted' -> [ context sourceNodeExecuted ]).
		  ('the context printed' -> [ context printString ]).
		  ('contextInconsistencies' -> [ reifiedMemory stacks contextInconsistencies ]).
		  ('source readability' -> [ reifiedMemory sourceReadability canRead: #source ]) }
