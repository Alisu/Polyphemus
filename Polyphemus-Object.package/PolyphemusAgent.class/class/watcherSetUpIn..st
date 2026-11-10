source
watcherSetUpIn: aDirectory

	"A semaphore of its own, registered where the VM can signal it from outside, and its index
	left in aDirectory for us to signal it by: on any VM (VM 10 no longer lets us set the
	interrupt flag), and without taking Pharo's own interrupt semaphore."

	^ (self directorySetUpIn: aDirectory) , '
interrupt := Semaphore new.
(dir / ''semaphore-index.tmp'') ensureDelete; writeStreamDo: [ :stream |
	stream print: (Smalltalk registerExternalObject: interrupt) ].
(dir / ''semaphore-index'') ensureDelete.
(dir / ''semaphore-index.tmp'') renameTo: ''semaphore-index''.'
