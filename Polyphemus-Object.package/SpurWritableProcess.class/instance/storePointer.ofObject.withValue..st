objects
storePointer: anIndex ofObject: anOop withValue: aWord

	"As the VM stores: an old object given a young one is remembered, or the next scavenge would
	move the young one without telling it."

	((aWord bitAnd: 7) = 0 and: [ self isYoung: aWord ]) ifTrue: [ self remember: anOop ].
	^ super storePointer: anIndex ofObject: anOop withValue: aWord
