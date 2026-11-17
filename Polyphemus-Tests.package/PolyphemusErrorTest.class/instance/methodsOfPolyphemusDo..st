running
methodsOfPolyphemusDo: aBlock

	"Each method of Polyphemus's own packages outside its tests, helpers and builder: those of its
	classes, and those it adds to the classes of others (Pharo's, VMMaker's)."

	(PolyphemusEdition packageOrganizer packages select: [ :each |
		 (each name beginsWith: 'Polyphemus-') and: [
			 #( 'Tests' 'Helper' 'Builder' ) noneSatisfy: [ :role | each name includesSubstring: role ] ] ]) do: [ :package |
		(package methods reject: [ :method |
			 method isFromTrait or: [ method methodClass instanceSide inheritsFrom: TestCase ] ]) do: aBlock ]
