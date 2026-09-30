helpers
putSourcesAndChangesBeside: anImage

	"A written image looks for its sources and changes beside it; Pharo 14 does not start
	without them (#38). Put afresh (an image started without them leaves empty ones), changes
	copied since the image may write them. The pinned images' own directory is left alone."

	| image pinned name changes |
	image := anImage asFileReference.
	pinned := PharoImageAccessor pathToTargetImage asFileReference.
	image parent = pinned parent ifTrue: [ ^ self ].
	name := PharoImageAccessor sourcesNameForPharo: PharoImageAccessor targetPharo.
	(image parent / name) ensureDelete.
	LibC system: 'ln -s ' , (pinned parent / name) resolve fullName , ' ' , (image parent / name) fullName.
	changes := image withExtension: 'changes'.
	changes ensureDelete.
	(pinned withExtension: 'changes') copyTo: changes
