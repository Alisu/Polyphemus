tests
testAScopeThatIsNoObjectWithSlotsGivesNoNames

	"#118: a layout whose scope is a tagged word, or a scope one of whose entries is. Each refuses
	its slots by name: the class has no names, or that name stands as unreadable in its place."

	| tagged scope class |
	tagged := OOPImmediate on: 16r29 memory: nil.
	class := ReifiedSlotsDouble slots: { nil. nil. nil. (ReifiedSlotsDouble slots: { nil. [ tagged ] }) }.
	self assert: (PharoMode new getObjectSlotNames: class) asArray equals: #(  ).

	scope := ReifiedSlotsDouble slots: { nil. (ReifiedSlotsDouble slots: { #a }). [ tagged ] }.
	class := ReifiedSlotsDouble slots: { nil. nil. nil. (ReifiedSlotsDouble slots: { nil. scope }) }.
	self assert: (PharoMode new getObjectSlotNames: class) asArray equals: #( #a '(unreadable name)' )
