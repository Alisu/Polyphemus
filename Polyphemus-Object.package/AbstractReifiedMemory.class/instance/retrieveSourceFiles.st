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
			((self sourceFileNamed: sourcePath fullName locations: { rootPath fullName })
				 tryOpenReadOnly: true) ].
	"Pharo reads through both files or neither: with no .changes, a stand-in (#16). Not empty:
	Pharo 14 refuses to open an empty one. Nothing in such an image points into it."
	changesPath ifNil: [
		changesPath := FileLocator temp / 'polyphemus-no-changes.changes'.
		(changesPath exists and: [ changesPath size > 0 ]) ifFalse: [
			changesPath writeStreamDo: [ :stream |
				stream nextPutAll: '"This image has no .changes file."!' ] ] ].
	sourceFiles changesFileStream:
		((self sourceFileNamed: changesPath fullName locations: { changesPath parent fullName })
			 tryOpenReadOnly: true).

	^ sourceFiles
