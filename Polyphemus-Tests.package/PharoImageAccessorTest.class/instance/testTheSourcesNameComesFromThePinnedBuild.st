tests
testTheSourcesNameComesFromThePinnedBuild

	"The name an image looks for its sources under carries its build's sha (#38). Pharo 13's
	carries 13.1 and a shorter sha than its download's: read from the download, not derived."

	self
		assert: (PharoImageAccessor sourcesNameForPharo: 10)
		equals: 'Pharo10.0-64bit-0542643.sources'.
	self
		assert: (PharoImageAccessor sourcesNameForPharo: 12)
		equals: 'Pharo12.0-64bit-aa50f9c.sources'.
	self
		assert: (PharoImageAccessor sourcesNameForPharo: 13)
		equals: 'Pharo13.1-64bit-d7c6f76.sources'
