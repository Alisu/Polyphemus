running
repositoryDirectory

	"Where this repository is checked out, as Iceberg has it registered -- which is how the
	fixture images are found as well, so it is already true wherever the suite can run."

	^ (IceRepository registeredRepositoryIncludingPackage:
		   (RPackageOrganizer default packageNamed: 'Polyphemus-Object')) location
