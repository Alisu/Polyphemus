instance creation
copyOf: aPid

	"What a reading needs of a running VM, copied while it is held still at a safe moment, quiet or
	else outside a collection (#66, #113), to be read as a core is once it has run on, or ended."

	| reader |
	reader := self on: aPid.
	^ [ reader whileStoppedToRead: [ :stopped | ProcessMemoryCopy of: stopped ] ] ensure: [ reader close ]