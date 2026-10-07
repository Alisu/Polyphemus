tests
testATestPackageIsItsOwn

	"The longest package name its category starts with, not the first."

	self assert: (self footprint packageOfClassNamed: 'OrderedCollectionTest') equals: 'Collections-Sequenceable-Tests'
