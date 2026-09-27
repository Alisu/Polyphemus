accessing
methodsTheWrittenImageDependsOn

	"Theirs, both sides, and what is added for the VMMaker in use: how a reading is laid out."

	^ (self classesTheWrittenImageDependsOn flatCollect: [ :each |
		   each methods , each class methods ])
	  , (RPackageOrganizer default packageNamed:
			   'Polyphemus-Edition-Pharo' , SystemVersion current major printString) methods
	  , ((RPackageOrganizer default packageNamed: 'Polyphemus-VMMaker-MemoryMap' ifAbsent: [ nil ])
			   ifNil: [ #(  ) ]
			   ifNotNil: [ :package | package methods ])
