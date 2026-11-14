tests
testADefectReadingALayoutIsNotALayoutWithoutNames

	"#118: a bug of our own while a class's layout was read gave a class with no names, or an
	unreadable name in the place of one."

	| layout class |
	layout := ReifiedSlotsDouble slots: { nil. [ 1 / 0 ] }.
	class := ReifiedSlotsDouble slots: { nil. nil. nil. (ReifiedSlotsDouble slots: { nil. layout }) }.
	self should: [ PharoMode new getObjectSlotNames: class ] raise: ZeroDivide.

	class := ReifiedSlotsDouble slots: { nil. nil. nil. [ 1 / 0 ] }.
	self should: [ PharoMode new getObjectSlotNames: class ] raise: ZeroDivide
