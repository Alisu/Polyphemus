compiled code
literalCountOf: aMethodOop

	"How many literals that method's header says; a header that is none is refused by name,
	where VMMaker asserts."

	| header |
	header := self methodHeaderOf: aMethodOop.
	(memory isIntegerObject: header) ifFalse: [
		^ (SpurCannotRead new level: #object reason: #itsHeaderIsNoHeader) signal ].
	^ memory literalCountOfMethodHeader: header
