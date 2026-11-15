tests
testADefectFindingAMethodsSourceIsNotAMethodWithoutArgumentsOrAPlaceInItsSource

	"#118: a method whose source does not read names no argument, and one that does not compile
	here as the image compiled it says nowhere for a pc. A bug of our own on the way is neither."

	self should: [ (self methodReadThroughADefectIn: #retrieveSourceFiles) argumentNames ] raise: ZeroDivide.
	self should: [ (self methodReadThroughADefectIn: #hostMethodOfMethod:) sourceNodeForPC: 1 ] raise: ZeroDivide
