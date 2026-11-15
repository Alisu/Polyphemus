tests
testADefectReadingAGlobalsValueIsNotAValueThatDoesNotRead

	"#118: a bug of our own while a global's value was read gave the binding itself as its value."

	| class binding |
	binding := self defective: (self memory globalNamed: #Transcript) in: #reifiedSlotAt:.
	class := (self memory oopClassNamed: 'Point') copy.
	class memory: ((DefectiveReadDouble of: self memory) when: #globalNamed: answer: [ binding ]).

	self should: [ class bindingOf: #ANameNoOtherTestAsks ] raise: ZeroDivide
