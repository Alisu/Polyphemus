tests
testWhereCompiledMethodDoesNotTellItsMethodsTheTrailersAreTakenForVariableAndSourcesStillRead

	"#118: how an image writes its trailers is told by a method of CompiledMethod class. With one
	of its methods unnamed that cannot be told, and the trailers are taken for variable, which
	this Pharo 10 image's are: one damaged method does not cost every source. A guess, kept so."

	| context |
	context := (reifiedMemory contextsOfProcess: reifiedMemory allReifiedProcesses first) first.

	self
		should: [ (reifiedMemory oopClassNamed: 'CompiledMethod') oopClass methodNamed: 'trailerSize' ifAbsent: [ nil ] ]
		raise: NotInTheReading.
	self assert: reifiedMemory methodTrailerClass equals: OOPVariableMethodTrailer.
	self assert: (reifiedMemory stacks sourceOfContext: context) notNil
