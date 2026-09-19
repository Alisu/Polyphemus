sources
retrieveSourceFiles

	"The target image's source files, recreated here since the image's own objects can change
	at startup. Matched by name: a Pharo 11 .sources reads as nonsense for a Pharo 10
	image."

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
	"Pharo reads through both files or neither: with no .changes, an empty one (#16)."
	changesPath ifNil: [
		changesPath := FileLocator temp / 'polyphemus-no-changes.changes'.
		changesPath ensureCreateFile ].
	sourceFiles changesFileStream:
		((SourceFile on: changesPath fullName potentialLocations: { changesPath parent fullName })
			 tryOpenReadOnly: true).

	^ sourceFiles
