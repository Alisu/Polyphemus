tests
testAPcAfterASendTranslatesToThatSend

	"A caller's pc has moved past its send; highlighting reads it one back, which lands inside
	or just after the send and must still find it."

	| usual longer ours theirs |
	usual := self compile: 'foo ^ x + (self bar: y)' options: #(  ).
	longer := self
		          compile: 'foo ^ x + (self bar: y)'
		          options: #( + optionLongIvarAccessBytecodes ).
	ours := SendSequence of: usual.
	theirs := SendSequence of: longer.

	self
		assert: (ours pcIn: theirs for: ours sendPCs first)
		equals: theirs sendPCs first.
	self
		assert: (ours pcIn: theirs for: ours sendPCs first - 1)
		equals: theirs sendPCs first
