tests
testItCountsTheInstancesOfEachClassAsAnIndependentReaderDid

	"The counts a Python reader of the same file found (#69, 2026-10-06): two readers that
	share no code."

	{
		('UndefinedObject' -> 1).
		('Array' -> 139898).
		('CompiledMethod' -> 132052).
		('ByteArray' -> 712).
		('MethodDictionary' -> 22260).
		('ByteSymbol' -> 86632).
		('StrikeFont' -> 80) } do: [ :each |
		self assert: (self census countOf: each key) equals: each value ]
