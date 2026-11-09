tests
testAnUnreadableNameKeepsItsPlace

	"#118: an entry of a class's layout that did not read was left out, and every later name then
	named the slot before its own. It keeps its place, saying it was not read."

	| layout class |
	layout := ReifiedSlotsDouble slots: {
		          nil.
		          (ReifiedSlotsDouble slots: { #a }).
		          [ self error: 'this slot does not read' ].
		          (ReifiedSlotsDouble slots: { #c }) }.
	class := ReifiedSlotsDouble slots: { nil. nil. nil. (ReifiedSlotsDouble slots: { nil. layout }) }.

	self assert: (PharoMode new getObjectSlotNames: class) asArray equals: #( #a '(unreadable name)' #c )
