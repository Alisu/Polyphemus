writing
writeTo: aPath

	"The dump as an image file, written by VMMaker's SpurImageWriter: what a dump needs and
	a running VM's snapshot does for itself (its headers, its frames), then VMMaker's own
	collection and writer."

	self prepareInterpreter.
	self restoreJittedHeaders.
	self describeOldSpaceUpTo: dumped raw mappingLimit plantingBridge: false.
	self prepareMemory.
	self divorceFrames.
	self collect.
	self
		describeOldSpaceUpTo: self trimTheFreeSpaceAtTheEnd + dumped memory bridgeSize
		plantingBridge: true.
	dumped interpreter imageName: aPath asFileReference fullName.
	dumped interpreter writeImageFileIO.
	^ aPath asFileReference
