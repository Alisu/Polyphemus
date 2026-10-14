tests
testThePinnedImageFindsItsOwnSources

	"Renamed cleanP10.sources on download, the sources were never where the image looks, and
	it said so on every start (#38). Pharo 14's macOS VM says it has no libgit2 before."

	| answer |
	answer := self evaluate: '3 + 4' in: PharoImageAccessor pathToPharo10 asFileReference.
	self assert: answer lines last equals: '7'.
	self deny: (answer includesSubstring: 'sources')
