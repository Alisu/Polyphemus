watching
during: aBlock

	"The heaps read while aBlock runs."

	| previous watch |
	previous := current.
	watch := self new.
	current := watch.
	[ aBlock value ] ensure: [ current := previous ].
	^ watch heaps
