tests
testATableWhosePagesAreGoneCannotBeRead

	"This is the damage that really does stop everything: a page of the wrong size means the
	arithmetic turning a class index into an entry has nowhere to land, so no object
	anywhere can be given a class. That is worth refusing over, and it is refused by name."

	| space dumped raised |
	space := self spaceFor: (self heapWithAPageOfTheWrongSize).
	dumped := SpurDumpedMemory
		          on: space
		          from: self baseAddress
		          to: self baseAddress + space size.

	self assert: (dumped readability canRead: #objects).
	self deny: (dumped readability canRead: #classes).
	self
		assert: (dumped readability whyNot: #classes)
		equals: #classTablePageIsTheWrongSize.

	raised := [ dumped reifiedMemory. nil ]
		          on: SpurCannotRead
		          do: [ :error | error ].
	self assert: raised isNotNil.
	self assert: raised level equals: #classes
