enumerating
instancesOfClassTag: aClassTag

	"Every object in the heap whose class carries this tag.

	It is a walk over every reified object -- ten million of them for a real image, three
	seconds -- and the answer cannot change while the reified view stays as it is. So it is
	remembered until that view is built again, which is what #snapshotMemory does and what
	anything writing to the memory underneath already has to call before the reified side
	shows its writes."

	instancesByClassTag ifNil: [ instancesByClassTag := Dictionary new ].
	^ instancesByClassTag
		  at: aClassTag
		  ifAbsentPut: [ self select: [ :anOop | anOop oopClassTag = aClassTag ] ]
