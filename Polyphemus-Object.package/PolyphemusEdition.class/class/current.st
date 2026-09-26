accessing
current

	"The edition this code is -- as the package loaded for this host says (forThisHost) --
	unless a test says otherwise (using:during:)."

	^ inUse ifNil: [ self forThisHost ]
