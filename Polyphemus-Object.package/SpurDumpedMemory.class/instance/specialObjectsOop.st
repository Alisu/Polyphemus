accessing
specialObjectsOop

	^ specialObjectsOop ifNil: [ self findHeap. specialObjectsOop ]
