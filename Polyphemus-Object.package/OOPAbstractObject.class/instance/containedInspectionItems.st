inspection
containedInspectionItems

	"Its slots, each under the name its class gives it. Where the class does not tell the names,
	or tells more than it has slots, they are under their numbers: a name on the wrong slot is
	worse than none (#205, #193)."

	| res slotNames slots |
	slots := self allReifiedSlots.
	res := OrderedCollection new: slots size + 1.
	res add: #oopNumberOfSlots -> slots size.
	slotNames := [ self oopClass allOopSlotNames ] on: PolyphemusError do: [ :refusal | #(  ) ].
	slotNames size > slots size ifTrue: [ slotNames := #(  ) ].
	slots doWithIndex: [ :each :anIndex |
		res add: (anIndex <= slotNames size
				 ifTrue: [ '(' , anIndex asString , ') ' , (slotNames at: anIndex) asString ]
				 ifFalse: [ 'slot ' , anIndex printString ]) -> each ].
	^ res
