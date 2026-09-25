tests
testItReadsBackWhatItWrote

	"From the edited bytes, not the file as it was: a second edit is aimed by what the first
	one left."

	| specials |
	specials := memory raw specialObjectsOop.
	memory storePointer: 0 ofObject: specials withValue: (memory smallIntegerOop: 42).
	self assert: (memory fetchPointer: 0 ofObject: specials) equals: 42 * 8 + 1.
	self assert: (memory raw scanner slotOf: specials at: 1) ~= (42 * 8 + 1)
