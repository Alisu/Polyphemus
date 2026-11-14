tests
testADefectWhileEveryObjectIsReifiedIsNotAWordThatIsNoObject

	"#118: any error while every object was reified was taken for a word that is no object, and
	asked which word it was."

	reifiedMemory := FullyReifiedMemory on: memory.
	reifiedMemory addObjectHandler: DefectiveObjectHandlerDouble.

	self should: [ reifiedMemory reifyAllOops ] raise: ZeroDivide
