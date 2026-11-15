tests
testADefectReadingAMethodsClassOrSelectorIsNotOneSaidUnreadableWhereItPrints

	"#118, #206: a method prints 'an unreadable class' or 'an unreadable selector' where one does
	not read. A bug of our own reading either is not that. Each defect is planted where the
	literal is kept, and taken out."

	| memory method |
	memory := self memory.
	method := self method.
	{ (method lastLiteral -> #reifiedSlotAt:). (method penultimateLiteral -> #oopClassName) } do: [ :each |
		memory objectAt: each key address put: ((DefectiveReadDouble of: each key) when: each value answer: [ 1 / 0 ]).
		[ self should: [ method printString ] raise: ZeroDivide ] ensure: [ memory objectAt: each key address put: each key ] ]
