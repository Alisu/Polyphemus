tests
testEveryVersionWeTargetIsPinnedWithItsSources

	"Each edition's live and editing tests run on its own version's image (#44): that image must
	not move under them, and must find its sources."

	10 to: 14 do: [ :version |
		self deny: ((PharoImageAccessor downloadNameForPharo: version) includesSubstring: 'latest').
		self assert: (PharoImageAccessor sourcesNameForPharo: version) notNil ].
	self
		assert: (PharoImageAccessor downloadNameForPharo: 11)
		equals: 'Pharo11-SNAPSHOT.build.688.sha.cf3d3fd.arch.64bit'.
	self
		assert: (PharoImageAccessor sourcesNameForPharo: 11)
		equals: 'Pharo11.0-64bit-cf3d3fd.sources'
