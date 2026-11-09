tests
testEveryNameIsReadInOrder

	| layout class |
	layout := ReifiedSlotsDouble slots: { nil. (ReifiedSlotsDouble slots: { #a }). (ReifiedSlotsDouble slots: { #b }) }.
	class := ReifiedSlotsDouble slots: { nil. nil. nil. (ReifiedSlotsDouble slots: { nil. layout }) }.

	self assert: (PharoMode new getObjectSlotNames: class) asArray equals: #( #a #b )
