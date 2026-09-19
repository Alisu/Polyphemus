*Polyphemus-Memory
defaultEdenBytes

	"VMMaker's default eden size, 4 MB for 32 bits and 7 MB for 64 (settable through
	vmParameterAt: or the ini file); its reasoning is in VMMaker's own method."

	<inline: false>
	^ 7 * 1024

	"Here are the expressions used to collect the above-mentioned figures:"
	"freeStart - self newSpaceStart"
	"| n | n := 0. self allNewSpaceObjectsDo: [:o| n := n + 1]. n"
	"| f | f := 0. self allNewSpaceObjectsDo: [:o| (self isFloatObject: o) ifTrue: [f := f + 1]]. f"
	"| l | l := 0. self allNewSpaceObjectsDo: [:o|
		(((self classIndexOf: o)
			between: ClassLargeNegativeIntegerCompactIndex
			and: ClassLargePositiveIntegerCompactIndex)
		 and: [(self numBytesOfBytes: o) <= 8
		 and: [self isIntegerValue: (coInterpreter signed64BitValueOf: o)]]) ifTrue: [l := l + 1]]. l"