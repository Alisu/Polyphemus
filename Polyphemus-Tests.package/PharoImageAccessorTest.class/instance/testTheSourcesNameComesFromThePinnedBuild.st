tests
testTheSourcesNameComesFromThePinnedBuild

	"The name an image looks for its sources under carries its build's sha (#38)."

	self
		assert: (PharoImageAccessor sourcesNameForPharo: 10)
		equals: 'Pharo10.0-64bit-0542643.sources'
