running
dumpFile

	"A core of a real VM. It is 200 MB, so it is not in the repository: `bin/take-dump.sh`
	makes one, and these tests skip without it.

	Looked for in `POLYPHEMUS_CORE` if that is set, and otherwise next to this image -- which
	is where `bin/take-dump.sh` writes it, and a place every machine has."

	^ (Smalltalk os environment at: 'POLYPHEMUS_CORE' ifAbsent: [ nil ])
		  ifNil: [ FileLocator imageDirectory / 'pharo.core' ]
		  ifNotNil: [ :path | path asFileReference ]
