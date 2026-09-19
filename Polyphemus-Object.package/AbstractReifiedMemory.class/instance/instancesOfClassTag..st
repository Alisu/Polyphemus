enumerating
instancesOfClassTag: aClassTag

	"Every reified object with this class tag. Cached until #snapshotMemory rebuilds the
	view."

	instancesByClassTag ifNil: [ instancesByClassTag := Dictionary new ].
	^ instancesByClassTag
		  at: aClassTag
		  ifAbsentPut: [ self select: [ :anOop | anOop oopClassTag = aClassTag ] ]
