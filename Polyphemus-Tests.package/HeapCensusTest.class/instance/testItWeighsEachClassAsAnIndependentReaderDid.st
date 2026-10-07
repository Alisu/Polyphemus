tests
testItWeighsEachClassAsAnIndependentReaderDid

	"Bytes, headers included, as the Python reader found them to the nearest 10 KB."

	{
		('Array' -> 13380000).
		('CompiledMethod' -> 11710000).
		('ByteArray' -> 8330000).
		('MethodDictionary' -> 2870000) } do: [ :each |
		self assert: ((self census bytesOf: each key) - each value) abs < 5000 ]
