tests
testValuesAreDescribedAsTheImagePrintsThem

	"nil, true, false, a symbol, a class, and anything else by its class with an article."

	| association |
	self assert: (self memory oopClassNamed: 'Object') inImageDescription equals: 'Object'.
	association := self anInstanceOf: 'Association' suchThat: [ :each | (each reifiedSlotAt: 1) inImageDescription first = $# ].
	self assert: ((association reifiedSlotAt: 1) inImageDescription beginsWith: '#').
	self assert: (self anInstanceOf: 'OrderedCollection' suchThat: [ :each | true ]) inImageDescription equals: 'an OrderedCollection'.
	self assert: (self anInstanceOf: 'Set' suchThat: [ :each | true ]) inImageDescription equals: 'a Set'
