running
whatIsShownOfFrame: anIndex

	"What the tools show of the process, of its stack and of the frame at that place when the
	stack still has one, each named: these answer, whatever the damage."

	| stacks frame |
	stacks := memory stacks.
	frame := [ self frames at: anIndex ifAbsent: [ nil ] ].
	^ {
		  ('activationsOfProcess:' -> [ stacks activationsOfProcess: process ]).
		  ('whyTheStackEndsOfProcess:' -> [ stacks whyTheStackEndsOfProcess: process ]).
		  ('contextsOfProcess:' -> [ stacks contextsOfProcess: process ]).
		  ('processStates' -> [ memory processStates ]).
		  ('whyTheStackEndsAfter:' -> [ frame value ifNotNil: [ :it | stacks whyTheStackEndsAfter: it ] ]).
		  ('descriptionOfContext:' -> [ frame value ifNotNil: [ :it | stacks descriptionOfContext: it ] ]).
		  ('sourceOfContext:' -> [ frame value ifNotNil: [ :it | stacks sourceOfContext: it ] ]).
		  ('disassemblyOfContext:' -> [ frame value ifNotNil: [ :it | stacks disassemblyOfContext: it ] ]).
		  ('stackFrom:ofSize:' -> [ frame value ifNotNil: [ :it | stacks stackFrom: it ofSize: 40 ] ]).
		  ('highlightRangeOf:active: false' -> [ frame value ifNotNil: [ :it | memory highlightRangeOf: it active: false ] ]).
		  ('highlightRangeOf:active: true' -> [ frame value ifNotNil: [ :it | memory highlightRangeOf: it active: true ] ]).
		  ('tempNamesOf:' -> [ frame value ifNotNil: [ :it | memory tempNamesOf: it ] ]) }
	  , (#( #selector #startpc #endPC #isBlockContext #sourceCode #tempNames #printString #isReadable
		     #isMachineCodeFrame #isActiveFrame #isDead #inspectionItems #readsMachineCodePC ) collect: [ :each |
			   each -> [ frame value ifNotNil: [ :it | it perform: each ] ] ])
