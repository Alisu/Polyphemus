compiled code
literalCountOf: aMethodOop

	"How many literals that method's header says; a header that is none, or that counts more
	literals than the object has slots, is refused by name, where VMMaker asserts or reads on
	past the object (#208)."

	| header count |
	header := self methodHeaderOf: aMethodOop.
	(memory isIntegerObject: header) ifFalse: [
		^ (SpurCannotRead new level: #object reason: #itsHeaderIsNoHeader) signal ].
	count := memory literalCountOfMethodHeader: header.
	count < (memory numSlotsOfAny: aMethodOop) ifFalse: [
		^ (SpurCannotRead new level: #object reason: #itsHeaderCountsMoreLiteralsThanItHasSlots) signal ].
	^ count
