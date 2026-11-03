watching
during: aBlock

	"The watch of what aBlock reads and writes: the heaps to check once it ends, and what was found
	wrong in those it wrote."

	| previous watch |
	previous := current.
	watch := self new.
	current := watch.
	[ aBlock value ] ensure: [ current := previous ].
	^ watch
