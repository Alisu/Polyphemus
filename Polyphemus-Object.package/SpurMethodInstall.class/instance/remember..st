memory
remember: anOop

	"Tell the collector that this object may now point at a younger one. Nothing to tell when
	the memory is a reading: it has no collector running in it."

	^ false
