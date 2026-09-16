reading the map
segments

	"Every region the process has mapped, read once from `/proc/<pid>/maps`.

	Only the readable ones are kept, and the kernel's own oddities are left out: `[vvar]` and
	`[vsyscall]` are mapped and readable-looking but refuse to be read, and a walk that
	stumbled into one would report damage that is not there."

	^ segments ifNil: [
		  segments := ((self pathFor: 'maps') asFileReference contents lines
			               collect: [ :line | self segmentFrom: line ])
			              reject: [ :each | each isNil ] ]
