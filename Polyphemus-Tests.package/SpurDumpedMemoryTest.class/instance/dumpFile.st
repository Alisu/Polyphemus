running
dumpFile

	"A core of a real VM (200 MB, not in the repository): `POLYPHEMUS_CORE`, or else
	pharo.core next to this image, where `bin/take-dump.sh` writes it. Tests skip without it."

	^ (Smalltalk os environment at: 'POLYPHEMUS_CORE' ifAbsent: [ nil ])
		  ifNil: [ FileLocator imageDirectory / 'pharo.core' ]
		  ifNotNil: [ :path | path asFileReference ]
