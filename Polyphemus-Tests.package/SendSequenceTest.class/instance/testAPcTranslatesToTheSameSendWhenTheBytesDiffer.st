tests
testAPcTranslatesToTheSameSendWhenTheBytesDiffer

	"Long instance variable access makes the same sends at other pcs."

	| usual longer ours theirs |
	usual := self compile: 'foo ^ x + (self bar: y)' options: #(  ).
	longer := self
		          compile: 'foo ^ x + (self bar: y)'
		          options: #( + optionLongIvarAccessBytecodes ).
	ours := SendSequence of: usual.
	theirs := SendSequence of: longer.

	self deny: usual bytecodes = longer bytecodes.
	self deny: ours sendPCs asArray = theirs sendPCs asArray.
	ours sendPCs doWithIndex: [ :each :index |
		self assert: (ours pcIn: theirs for: each) equals: (theirs sendPCs at: index) ]
