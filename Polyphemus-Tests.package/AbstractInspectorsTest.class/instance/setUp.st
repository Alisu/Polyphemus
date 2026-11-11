running
setUp

	"Not VMMaker's set-up, which builds a simulated VM of its own: the memory read is a
	fixture image's (#118). The test's parameters applied as ParametrizedTestCase applies them."

	self applyTheTestParameters.
	resource := self resourceClass.
	self mutatesResource 
		ifTrue: [ self setUpCopy ]
		ifFalse: [ self setUpImmutable ]