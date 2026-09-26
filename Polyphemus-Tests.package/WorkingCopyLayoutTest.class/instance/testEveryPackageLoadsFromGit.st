tests
testEveryPackageLoadsFromGit

	"#52: a package made by hand without monticello.meta compiled here and did not load from
	GitHub, where Iceberg reads it to know a directory is a package."

	| root missing |
	root := (IceRepository registeredRepositoryIncludingPackage:
		         (RPackageOrganizer default packageNamed: 'Polyphemus-Object')) location.
	missing := (root directories select: [ :each | each basename endsWith: '.package' ])
		           reject: [ :each |
			           (each / '.filetree') exists and: [
				           #( 'package' 'categories.st' 'initializers.st' ) allSatisfy: [ :name |
					           (each / 'monticello.meta' / name) exists ] ] ].
	self assert: (missing collect: [ :each | each basename ]) asArray equals: #(  )
