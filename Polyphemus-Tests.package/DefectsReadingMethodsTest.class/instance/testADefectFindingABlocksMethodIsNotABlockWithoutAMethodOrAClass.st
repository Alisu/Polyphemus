tests
testADefectFindingABlocksMethodIsNotABlockWithoutAMethodOrAClass

	"#118, #208: a block whose method does not read prints 'an unreadable method' and answers no
	class to Pharo's compiler. A bug of our own finding it is neither. The defect is planted where
	the method is kept, and taken out."

	| memory block method |
	memory := self memory.
	block := ((memory oopClassNamed: 'Set') methodNamed: 'collect:' ifAbsent: [ self fail: 'no Set>>collect:' ])
		         allCompiledBlocks first.
	method := block lastLiteral.
	memory objectAt: method address put: ((DefectiveReadDouble of: method) when: #isCompiledMethodOop answer: [ 1 / 0 ]).
	[
	self should: [ block printString ] raise: ZeroDivide.
	self should: [ block methodClass ] raise: ZeroDivide ] ensure: [ memory objectAt: method address put: method ]
