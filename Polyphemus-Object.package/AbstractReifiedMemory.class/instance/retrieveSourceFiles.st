sources
retrieveSourceFiles

	"Here we have 2 choices:
	1/try to retrive the sourceFiles object contained in the image but they can be modified on startUp afterward.
	2/recreate ourselves a sourceFiles object pointing to the sourceFiles of the target image if any
	For now I chosed 2

	Pick the files belonging to this image by name, not the first ones lying around:
	several images share the resources directory, and a Pharo 11 .sources answers
	nonsense for a Pharo 10 image, quietly."

	| sourceFiles rootPath base sourcePath changesPath |
	rootPath := memory interpreter imageName asFileReference parent.
	base := memory interpreter imageName asFileReference basenameWithoutExtension.

	sourcePath := self
		              fileNamed: base , '.sources'
		              orAnyMatching: '*.sources'
		              in: rootPath.
	changesPath := self
		               fileNamed: base , '.changes'
		               orAnyMatching: '*.changes'
		               in: rootPath.

	sourceFiles := SourceFileArray new.
	sourcePath ifNotNil: [
		sourceFiles sourcesFileStream:
			((SourceFile on: sourcePath fullName potentialLocations: { rootPath fullName })
				 tryOpenReadOnly: true) ].
	changesPath ifNotNil: [
		sourceFiles changesFileStream:
			((SourceFile on: changesPath fullName potentialLocations: { rootPath fullName })
				 tryOpenReadOnly: true) ].

	^ sourceFiles
