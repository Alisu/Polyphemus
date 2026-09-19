accessing
specialObjectsOop

	"Nil when the heap holds no such array, which `SpurReadability` reports rather than
	raising: the objects are still readable, only the VM's well-known ones are not."

	^ specialObjectsOop ifNil: [ self findHeap. specialObjectsOop ]
