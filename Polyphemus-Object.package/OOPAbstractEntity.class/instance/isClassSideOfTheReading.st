testing
isClassSideOfTheReading

	"Whether a reading of another copy can take this wrapper over: a class, the class table or
	one of its pages -- what the reading is slow to build and a step does not move."

	^ self isClassOop or: [ self isClassTableOop or: [ self isClassTablePageOop ] ]
