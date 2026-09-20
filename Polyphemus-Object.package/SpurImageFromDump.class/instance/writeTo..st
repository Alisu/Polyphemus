writing
writeTo: aPath

	"The dump's old space as an image file, written by VMMaker's SpurImageWriter."

	self prepareInterpreter.
	self describeOldSpaceAsOneSegment.
	dumped interpreter imageName: aPath asFileReference fullName.
	dumped interpreter writeImageFileIO.
	^ aPath asFileReference
