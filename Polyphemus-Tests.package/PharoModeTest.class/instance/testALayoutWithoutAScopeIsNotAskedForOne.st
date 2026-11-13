tests
testALayoutWithoutAScopeIsNotAskedForOne

	"#118: the layout of bytes or of compiled methods has one slot and no scope of names. Its
	second slot was asked for, an error caught on every such class; it is asked how many it has."

	| class |
	class := ReifiedSlotsDouble slots: { nil. nil. nil. (ReifiedSlotsDouble slots: { nil }) }.

	self assert: (PharoMode new getObjectSlotNames: class) isEmpty
