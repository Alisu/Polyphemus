images
pathToTargetVM

	"The VM target images run on: POLYPHEMUS_TARGET_VM, or else the one running us. A Pharo 11
	host still reads Pharo 10 targets on their own VM (docs/editions.md)."

	^ Smalltalk os environment at: 'POLYPHEMUS_TARGET_VM' ifAbsent: [ Smalltalk vm fullPath ]
