tests
testAnyOtherObjectShowsItsInstanceVariablesByName

	| association |
	association := self anInstanceOf: 'Association' suchThat: [ :each | true ].
	self assert: (self labelsOf: association) asArray equals: #( 'key' 'value' )
