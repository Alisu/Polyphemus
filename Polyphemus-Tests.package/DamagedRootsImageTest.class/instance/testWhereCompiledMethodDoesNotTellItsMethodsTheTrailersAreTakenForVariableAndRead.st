tests
testWhereCompiledMethodDoesNotTellItsMethodsTheTrailersAreTakenForVariableAndRead

	"#118: how an image writes its trailers is told by a method of CompiledMethod class. With one
	of its methods unnamed that cannot be told, and they are taken for variable, as this Pharo 10
	image's are: a guess. Whether a source then reads depends on the host's files: not asked."

	| context |
	context := (reifiedMemory contextsOfProcess: reifiedMemory allReifiedProcesses first) first.

	self
		should: [ (reifiedMemory oopClassNamed: 'CompiledMethod') oopClass methodNamed: 'trailerSize' ifAbsent: [ nil ] ]
		raise: NotInTheReading.
	self assert: reifiedMemory methodTrailerClass equals: OOPVariableMethodTrailer.
	self assert: context homeMethod trailer class equals: OOPVariableMethodTrailer.
	self assert: context homeMethod trailer hasSourcePointer
