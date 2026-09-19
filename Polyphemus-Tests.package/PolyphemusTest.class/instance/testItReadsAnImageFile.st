tests
testItReadsAnImageFile

	"The first thing anyone tries, and the one the front door exists for: a path in, a memory
	with processes in it out, and no test class opened along the way.

	Candle, because it is small and ships with the repository."

	| memory |
	memory := Polyphemus readImageFile: PharoImageAccessor pathToCandle64Bit.

	self assert: memory allReifiedProcesses notEmpty
