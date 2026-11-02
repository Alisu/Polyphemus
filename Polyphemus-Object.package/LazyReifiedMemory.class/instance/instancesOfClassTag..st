enumerating
instancesOfClassTag: aClassTag

	"Every object with this class tag. Read in part, by one walk over the heap for that class, the
	others not reified (#129)."

	whole ifNil: [ ^ super instancesOfClassTag: aClassTag ].
	instancesByClassTag ifNil: [ instancesByClassTag := Dictionary new ].
	^ instancesByClassTag
		  at: aClassTag
		  ifAbsentPut: [ (whole addressesOfClassIndex: aClassTag) collect: [ :each | self reifyOop: each ] ]
