tests
testAFetchThatBringsNothingSaysSoOnce

	"A pinned image is fetched when missing; when the fetch brings nothing (no flock on macOS,
	no network), say which image and where, rather than fetching again forever."

	| fetches |
	fetches := 0.
	self
		should: [ PharoImageAccessor pathToImage: 'cleanNowhere99.image' fetchingWith: [ fetches := fetches + 1 ] ]
		raise: Error
		withExceptionDo: [ :e |
			self assert: (e messageText includesSubstring: 'cleanNowhere99.image').
			self assert: (e messageText includesSubstring: 'resources') ].
	self assert: fetches equals: 1
