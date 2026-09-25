tests
testAPcTranslatesToTheSameSendWhenTheBytesDiffer

	"Long instance variable access makes the same sends at other pcs. The code is compared
	byte by byte: not every Pharo 10 build has #bytecodes (#40)."

	| usual longer ours theirs codeOf |
	usual := self compile: 'foo ^ x + (self bar: y)' options: #(  ).
	longer := self
		          compile: 'foo ^ x + (self bar: y)'
		          options: #( + optionLongIvarAccessBytecodes ).
	ours := SendSequence of: usual.
	theirs := SendSequence of: longer.
	codeOf := [ :method |
	          (method initialPC to: method endPC) collect: [ :pc | method at: pc ] ].

	self deny: (codeOf value: usual) = (codeOf value: longer).
	self deny: ours sendPCs asArray = theirs sendPCs asArray.
	ours sendPCs doWithIndex: [ :each :index |
		self assert: (ours pcIn: theirs for: each) equals: (theirs sendPCs at: index) ]
