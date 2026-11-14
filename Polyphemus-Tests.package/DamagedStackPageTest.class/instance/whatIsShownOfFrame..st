running
whatIsShownOfFrame: anIndex

	"What the tools show of the page, of the running process and of the frame at that place when
	the page still has one, each named: these answer, whatever the damage."

	| stacks frame |
	stacks := reifiedMemory stacks.
	frame := [ self frames at: anIndex ifAbsent: [ nil ] ].
	^ {
		  ('the page''s frames' -> [ self frames ]).
		  ('livePages' -> [ stacks livePages ]).
		  ('activationsOfProcess:' -> [ stacks activationsOfProcess: reifiedMemory reifiedActiveProcess ]).
		  ('whyTheStackEndsOfProcess:' -> [ stacks whyTheStackEndsOfProcess: reifiedMemory reifiedActiveProcess ]).
		  ('whyTheStackEndsAfter:' -> [ frame value ifNotNil: [ :it | stacks whyTheStackEndsAfter: it ] ]).
		  ('descriptionOfContext:' -> [ frame value ifNotNil: [ :it | stacks descriptionOfContext: it ] ]).
		  ('sourceOfContext:' -> [ frame value ifNotNil: [ :it | stacks sourceOfContext: it ] ]).
		  ('disassemblyOfContext:' -> [ frame value ifNotNil: [ :it | stacks disassemblyOfContext: it ] ]).
		  ('stackFrom:ofSize:' -> [ frame value ifNotNil: [ :it | stacks stackFrom: it ofSize: 30 ] ]).
		  ('highlightRangeOf:active: false' -> [ frame value ifNotNil: [ :it | reifiedMemory highlightRangeOf: it active: false ] ]).
		  ('highlightRangeOf:active: true' -> [ frame value ifNotNil: [ :it | reifiedMemory highlightRangeOf: it active: true ] ]).
		  ('tempNamesOf:' -> [ frame value ifNotNil: [ :it | reifiedMemory tempNamesOf: it ] ]) }
	  , (#( #selector #startpc #endPC #isBlockContext #sourceCode #tempNames #printString #isReadable
		     #isMachineCodeFrame #isActiveFrame #isDead #inspectionItems ) collect: [ :each |
			   each -> [ frame value ifNotNil: [ :it | it perform: each ] ] ])
