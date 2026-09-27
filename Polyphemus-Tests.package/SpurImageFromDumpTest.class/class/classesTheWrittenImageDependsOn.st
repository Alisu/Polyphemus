accessing
classesTheWrittenImageDependsOn

	"Reading the dump, reifying it, and writing it out."

	| left |
	left := self classesTheWrittenImageLeavesOut.
	^ (PolyphemusEdition packageOrganizer packageNamed: 'Polyphemus-Object') definedClasses reject: [ :each |
		  left includes: each ]
