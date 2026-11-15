tests
testADefectBeforePharoIsAskedIsNotCodeThatDoesNotDisassemble

	"#118, #206: what Pharo's decoder raises over a method is taken for code that does not
	disassemble. Its literals are read before Pharo is asked, so a bug of our own reading them
	is not."

	self should: [ (self methodReadThroughADefectIn: #literalCountOf:) allSymbolicBytecodes ] raise: ZeroDivide
