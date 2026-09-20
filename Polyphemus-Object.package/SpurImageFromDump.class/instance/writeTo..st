writing
writeTo: aPath

	"The dump's old space as an image file, written by VMMaker's SpurImageWriter, after the
	passes a dump needs and a running VM's snapshot does for itself."

	self prepareInterpreter.
	self restoreJittedHeaders.
	self describeOldSpaceAsOneSegment.
	dumped interpreter imageName: aPath asFileReference fullName.
	dumped interpreter writeImageFileIO.
	^ aPath asFileReference
