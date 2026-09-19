compiled code
literalCountOf: aMethodOop

	^ memory literalCountOfMethodHeader: (self methodHeaderOf: aMethodOop)
