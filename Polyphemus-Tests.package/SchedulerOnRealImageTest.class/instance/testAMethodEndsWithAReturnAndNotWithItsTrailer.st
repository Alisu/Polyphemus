tests
testAMethodEndsWithAReturnAndNotWithItsTrailer

	"Every method ends by returning. If the last byte is not a return bytecode then the end
	of the method has been put in the wrong place, and everything that walks bytecodes --
	disassembly, and any attempt to match code against the source it came from -- walks off
	the end into the trailer, which is a source pointer and not code at all."

	| methods |
	methods := (self allFrames collect: [ :each | each homeMethod ]) asSet.

	self deny: methods isEmpty.
	methods do: [ :method |
		| last |
		last := method at: method endPC.
		self assert: (last between: 88 and: 95) ]
