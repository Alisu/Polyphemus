helpers
privateCopyOfTheTarget

	"The pinned image copied into the spike directory, its changes beside it: a target appends to
	them, and targets launched at once into one file pointed methods into each other's text (#145)."

	| pinned image |
	pinned := PharoImageAccessor pathToTargetImage asFileReference.
	image := self spikeDirectory / pinned basename.
	LibC system: 'cp "' , pinned fullName , '" "' , image fullName , '"'.
	self putSourcesAndChangesBeside: image.
	^ image
