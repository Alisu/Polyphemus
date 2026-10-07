tests
testAMetaclassIsNamedAfterItsClass

	self assert: (self census countOf: 'UndefinedObject class') equals: 1.
	self assert: (self census countOf: 'Metaclass') > 8000
