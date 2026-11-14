running
methodsOfPolyphemusDo: aBlock

	"Each method of Polyphemus's own classes outside its tests, helpers and builder."

	(Smalltalk allClassesAndTraits select: [ :each |
		 (each package name beginsWith: 'Polyphemus-') and: [
			 (#( 'Tests' 'Helper' 'Builder' ) noneSatisfy: [ :role | each package name includesSubstring: role ])
				 and: [ (each inheritsFrom: TestCase) not ] ] ]) do: [ :class |
		(class methods , class class methods reject: [ :method | method isFromTrait ]) do: aBlock ]
