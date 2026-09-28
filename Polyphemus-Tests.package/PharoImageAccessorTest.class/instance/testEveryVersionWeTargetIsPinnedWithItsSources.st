tests
testEveryVersionWeTargetIsPinnedWithItsSources

	"Each edition's live and editing tests run on its own version's image (#44): that image must
	not move under them, and must find its sources."

	10 to: 14 do: [ :version |
		self deny: ((PharoImageAccessor downloadNameForPharo: version) includesSubstring: 'latest').
		self assert: (PharoImageAccessor sourcesNameForPharo: version) notNil ].
	self
		assert: (PharoImageAccessor downloadNameForPharo: 11)
		equals: 'Pharo11-SNAPSHOT.build.750.sha.963dc3a7de.arch.64bit'.
	self
		assert: (PharoImageAccessor sourcesNameForPharo: 11)
		equals: 'Pharo11.0-64bit-963dc3a.sources'
