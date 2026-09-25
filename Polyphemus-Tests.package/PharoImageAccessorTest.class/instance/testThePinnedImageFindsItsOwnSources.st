tests
testThePinnedImageFindsItsOwnSources

	"Renamed cleanP10.sources on download, the sources were never where the image looks, and
	it said so on every start -- into whatever read its answer (#38)."

	self assert: (self evaluate: '3 + 4' in: PharoImageAccessor pathToPharo10 asFileReference) equals: '7'
