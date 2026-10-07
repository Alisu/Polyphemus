tests
testAClassAndItsMetaclassBelongToTheirPackage

	"Pharo 10 and 11 say it by the category Collections-Sequenceable-Ordered, a package name
	and a tag; Pharo 12 to 14 by the class's PackageTag."

	self assert: (self footprint packageOfClassNamed: 'OrderedCollection') equals: 'Collections-Sequenceable'.
	self assert: (self footprint packageOfClassNamed: 'OrderedCollection class') equals: 'Collections-Sequenceable'
