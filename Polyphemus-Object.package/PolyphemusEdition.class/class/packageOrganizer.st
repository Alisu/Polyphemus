host
packageOrganizer

	"This host's packages: RPackageOrganizer up to Pharo 12, PackageOrganizer from Pharo 13."

	^ (Smalltalk globals at: #RPackageOrganizer ifAbsent: [ Smalltalk globals at: #PackageOrganizer ])
		  default
