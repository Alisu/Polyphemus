tests
testADefectReadingAClassVariablesNameIsNotANameThatDoesNotRead

	"#118: a class variable whose name does not read keeps its place as '(unreadable name)'; a bug
	of our own reading the name is not that."

	| class mode |
	mode := self defective: self memory mode in: #nameForClassVariable:.
	class := (self memory oopClassNamed: 'Color') copy.
	class memory: ((DefectiveReadDouble of: self memory) when: #mode answer: [ mode ]).

	self should: [ class oopAllClassVariablesNames ] raise: ZeroDivide
