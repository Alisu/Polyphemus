tests
testADefectAskingHowTheImageWritesItsTrailersIsNotAnImageWithVariableOnes

	"#118: an image whose CompiledMethod does not tell its methods is taken to write variable
	trailers. A bug of our own asking is not that. The defect is planted where the class is kept,
	and taken out; what the reading had worked out is forgotten before and after."

	| memory class |
	memory := self memory.
	class := memory oopClassNamed: 'CompiledMethod'.
	memory objectAt: class address put: (self defective: class in: #oopClass).
	memory forgetWhatWasRead.
	[ self should: [ memory methodTrailerClass ] raise: ZeroDivide ] ensure: [
		memory objectAt: class address put: class.
		memory forgetWhatWasRead ]
