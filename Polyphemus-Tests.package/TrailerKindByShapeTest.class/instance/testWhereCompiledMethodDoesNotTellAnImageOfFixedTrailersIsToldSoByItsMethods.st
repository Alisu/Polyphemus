tests
testWhereCompiledMethodDoesNotTellAnImageOfFixedTrailersIsToldSoByItsMethods

	"#118: a Pharo 12 image says its trailers are fixed by a method of CompiledMethod class named
	trailerSize. With that method's selector overwritten the class no longer tells, and the
	trailers were taken for variable: a guess, wrong here. The methods' last bytes tell."

	| method slot before |
	self assert: reifiedMemory methodTrailerClass equals: OOPFixedMethodTrailer.
	method := (reifiedMemory oopClassNamed: 'CompiledMethod') oopClass
		          methodNamed: 'trailerSize'
		          ifAbsent: [ self fail: 'no CompiledMethod class>>trailerSize in this image' ].
	slot := method numberOfLiterals - 1.
	before := memory fetchPointer: slot ofObject: method address.
	memory storePointerUnchecked: slot ofObject: method address withValue: 0.
	reifiedMemory forgetWhatWasRead.
	[
	self
		should: [ (reifiedMemory oopClassNamed: 'CompiledMethod') oopClass methodNamed: 'trailerSize' ifAbsent: [ nil ] ]
		raise: NotInTheReading.
	self assert: reifiedMemory methodTrailerClass equals: OOPFixedMethodTrailer ] ensure: [
		memory storePointerUnchecked: slot ofObject: method address withValue: before.
		reifiedMemory forgetWhatWasRead ]
