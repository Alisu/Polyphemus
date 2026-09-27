accessing
methodsTheWrittenImageDependsOn

	"Theirs, both sides, and what the edition adds for its VMMaker: how a reading is laid out."

	^ (self classesTheWrittenImageDependsOn flatCollect: [ :each |
		   each methods , each class methods ])
	  , (RPackageOrganizer default packageNamed:
			   'Polyphemus-Edition-Pharo' , SystemVersion current major printString) methods
