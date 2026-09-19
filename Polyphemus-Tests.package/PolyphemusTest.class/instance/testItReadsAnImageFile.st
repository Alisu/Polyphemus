tests
testItReadsAnImageFile

	"A path in, a memory with processes out, with no test class opened on the way. Candle,
	because it is small and in the repository."

	| memory |
	memory := Polyphemus readImageFile: PharoImageAccessor pathToCandle64Bit.

	self assert: memory allReifiedProcesses notEmpty
