tests
testItAnswersItsObjectsInAddressOrder

	table at: 16r10000000010 put: #old.
	table at: 16r340000008 put: #young.
	self assert: (table select: [ :each | each notNil ]) asArray equals: #( #young #old ).
	self
		assert: ((table collect: [ :each | each ifNotNil: [ each size ] ]) at: 16r10000000010)
		equals: 3
