instance creation
writeDumpOf: aPid to: aPath

	"A core file of a running VM, written while it is held still at a safe moment (#66, #113)."

	| reader |
	reader := self on: aPid.
	^ [ reader whileStoppedToRead: [ :stopped | stopped writeDumpTo: aPath asFileReference ] ] ensure: [ reader close ]