tests
testADefectReadingAMethodsHeaderIsNotAMethodWithoutAClassASelectorOrAProperty

	"#118, #206: a method whose header does not read says so where its class and selector are,
	and answers Pharo's tools without them. A bug of our own counting its literals is not that."

	| method |
	method := self methodReadThroughADefectIn: #literalCountOf:.

	self should: [ method printString ] raise: ZeroDivide.
	self should: [ method selector ] raise: ZeroDivide.
	self should: [ method methodClass ] raise: ZeroDivide.
	self should: [ method propertyAt: #anyProperty ifAbsent: [ nil ] ] raise: ZeroDivide.
	self should: [ method compiledCodeInspectionItems ] raise: ZeroDivide.
	self should: [ method inspectionItems ] raise: ZeroDivide
