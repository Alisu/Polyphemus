tests
testAHoldLastsAnHourWithoutARequestUnlessSet

	| before |
	before := PolyphemusAgent holdLimit.
	[
	Polyphemus holdLimit: nil.
	self assert: Polyphemus holdLimit isNil.
	Polyphemus holdLimit: 2 hours.
	self assert: Polyphemus holdLimit equals: 2 hours.
	self assert: PolyphemusAgent holdLimit equals: 2 hours.
	PolyphemusAgent classVarNamed: #HoldLimit put: nil.
	self assert: Polyphemus holdLimit equals: 60 minutes ] ensure: [ PolyphemusAgent holdLimit: before ]
