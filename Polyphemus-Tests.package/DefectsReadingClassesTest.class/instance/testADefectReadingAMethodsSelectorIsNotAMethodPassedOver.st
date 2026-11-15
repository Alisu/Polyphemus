tests
testADefectReadingAMethodsSelectorIsNotAMethodPassedOver

	"#118, #205: a method whose selector does not read is passed over when one is sought by name;
	a bug of our own reading it is not that. The defect is planted where the method is kept, and
	taken out."

	| memory class method |
	memory := self memory.
	class := memory oopClassNamed: 'Point'.
	method := class reifiedMethods first.
	memory objectAt: method address put: (self defective: method in: #oopSelector).
	[ self should: [ class methodNamed: 'noSuchSelector' ifAbsent: [ nil ] ] raise: ZeroDivide ] ensure: [
		memory objectAt: method address put: method ]
