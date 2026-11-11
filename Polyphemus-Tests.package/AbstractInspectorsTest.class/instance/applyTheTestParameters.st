running
applyTheTestParameters

	"What ParametrizedTestCase>>setUp does, VMMaker's set-up between it and us left out: the
	parameters asked, or else the first set of them."

	self parametersToUse do: [ :each | each applyTo: self ].
	(self parametersToUse isEmpty and: [ self class testParameters isNotEmpty ]) ifTrue: [
		self class testParameters expandMatrix first do: [ :each | each applyTo: self ] ]
