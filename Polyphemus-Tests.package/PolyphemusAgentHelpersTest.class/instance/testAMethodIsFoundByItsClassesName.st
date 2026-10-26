tests
testAMethodIsFoundByItsClassesName

	self
		assert: ((workspace at: #methodNamed) value: 'PolyphemusAgentHelpersTest' value: #runnable)
		identicalTo: PolyphemusAgentHelpersTest >> #runnable.
	self
		assert: ((workspace at: #methodNamed) value: 'PolyphemusAgentHelpersTest class' value: #aClassSideMethod)
		identicalTo: PolyphemusAgentHelpersTest class >> #aClassSideMethod
