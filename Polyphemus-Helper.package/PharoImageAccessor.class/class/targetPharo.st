images
targetPharo

	"The version whose pinned image live tests launch and editing tests edit:
	POLYPHEMUS_TARGET_PHARO, or else 10. A host's setup names it in its polyphemus.env."

	^ (OSEnvironment current at: 'POLYPHEMUS_TARGET_PHARO' ifAbsent: [ '10' ]) asNumber
