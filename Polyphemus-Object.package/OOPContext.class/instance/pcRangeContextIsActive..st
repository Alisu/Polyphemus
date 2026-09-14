highlighting
pcRangeContextIsActive: contextIsActive

	"Where in the source this frame is, as an interval into the text the debugger is
	showing -- which is the source read from that image's own sources file, the same text
	the code was compiled from here.

	The rule is Pharo's own: the frame on top of the stack has its pc on the instruction
	about to run, while every frame below it has already advanced past the send it is
	waiting on, so theirs is read one back.

	An empty interval means nothing is highlighted, which is what a frame whose code cannot
	be reproduced answers. Highlighting the wrong line is worse than highlighting none."

	| code thePC |
	code := self faithfulCompiledCode.
	code ifNil: [ ^ 1 to: 0 ].

	thePC := self isDead
		         ifTrue: [ [ code endPC ] on: Error do: [ :e | self pc ] ]
		         ifFalse: [ self pc ].
	contextIsActive ifFalse: [ thePC := thePC - 1 ].

	^ [ code rangeForPC: thePC ] on: Error do: [ :e | 1 to: 0 ]
