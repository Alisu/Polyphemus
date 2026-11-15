running
whatIsShown

	"What the tools show of the processes of the image."

	^ {
		  ('processStates' -> [ reifiedMemory processStates ]).
		  ('processInconsistencies' -> [ reifiedMemory processInconsistencies ]).
		  ('the stack described' -> [ reifiedMemory stacks stackDescriptionOfProcess: process ]).
		  ('why the stack ends' -> [ reifiedMemory stacks whyTheStackEndsOfProcess: process ]).
		  ('the row of the MCP' -> [ PolyphemusMCPServer new rowOfProcess: process numbered: 1 in: reifiedMemory ]).
		  ('the process printed' -> [ process printString ]).
		  ('the process inspected' -> [ process inspectionItems ]).
		  ('contextInconsistencies' -> [ reifiedMemory stacks contextInconsistencies ]).
		  ('source readability' -> [ reifiedMemory sourceReadability refusals ]) }
