writing
writeTo: aPath

	"The image as it now is, through VMMaker's own writer."

	memory coInterpreter imageName: aPath asFileReference fullName.
	memory coInterpreter writeImageFileIO.
	^ aPath asFileReference
