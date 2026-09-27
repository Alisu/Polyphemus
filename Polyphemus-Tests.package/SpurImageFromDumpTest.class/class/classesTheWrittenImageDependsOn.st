accessing
classesTheWrittenImageDependsOn

	"Reading the dump, reifying it, and writing it out."

	| left |
	left := self classesTheWrittenImageLeavesOut.
	^ (RPackageOrganizer default packageNamed: 'Polyphemus-Object') definedClasses reject: [ :each |
		  left includes: each ]
