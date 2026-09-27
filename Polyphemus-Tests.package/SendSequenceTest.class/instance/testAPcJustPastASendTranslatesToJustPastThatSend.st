tests
testAPcJustPastASendTranslatesToJustPastThatSend

	"The top frame's pc is read as it is: just past its send, where the value the send answers
	is stored. It is there in the other code too, not at the next send."

	| usual longer ours theirs |
	usual := self compile: 'foo | t | t := self bar: y. ^ t + x' options: #(  ).
	longer := self
		          compile: 'foo | t | t := self bar: y. ^ t + x'
		          options: #( + optionLongIvarAccessBytecodes ).
	ours := SendSequence of: usual.
	theirs := SendSequence of: longer.

	self
		assert: (ours pcIn: theirs for: (ours endOfInstructionAt: ours sendPCs first))
		equals: (theirs endOfInstructionAt: theirs sendPCs first)
