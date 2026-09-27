accessing
classesTheWrittenImageLeavesOut

	"The live-image and editing code: what most changes touch, and what writing the dump's
	image does not use -- which DumpImageCacheKeyTest checks."

	^ (RPackageOrganizer default packageNamed: 'Polyphemus-Object') definedClasses select: [ :each |
		  (#( 'Polyphemus-Object-process' )
			   includes: each category asString) or: [
			  #( 'SpurEdit' 'SpurMethodFix' 'SpurMethodInstall' ) includes: each name asString ] ]
