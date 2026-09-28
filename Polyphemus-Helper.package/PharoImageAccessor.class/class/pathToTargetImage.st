images
pathToTargetImage

	"The pinned image live tests launch: POLYPHEMUS_TARGET_PHARO's version, or else Pharo 10's.
	A host's setup names it in its polyphemus.env (docs/editions.md)."

	^ self pathToPharo:
		  (OSEnvironment current at: 'POLYPHEMUS_TARGET_PHARO' ifAbsent: [ '10' ]) asNumber
