tests
testTopFrameIsAtInterpreterFramePointer

	"The first frame of the active page is the one the interpreter is executing."

	| frame |
	frame := stackPages mostRecentlyUsedPage frames first.

	self assert: frame framePointer equals: reifiedMemory interpreter framePointer
