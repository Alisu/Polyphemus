tests
testADefectReadingASuperclassIsNotAClassPassedOverWhenSubclassesAreRecorded

	"#118, #205: a reading's set-up passes over a class whose superclass does not read; a bug of
	our own reading it is not that."

	| memory table |
	memory := self memory.
	table := memory reifiedClassTable copy.
	table memory: ((DefectiveReadDouble of: memory) when: #allClassesOop answer: [
			 { (self defective: (memory oopClassNamed: 'Point') in: #oopSuperclass) } ]).

	self should: [ table computeSubclasses ] raise: ZeroDivide
