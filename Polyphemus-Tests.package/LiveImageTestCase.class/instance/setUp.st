running
setUp

	super setUp.
	(Smalltalk os isUnix and: [ '/proc/self/maps' asFileReference exists ]) ifFalse: [
		^ self skip: 'this reads /proc, which only Linux has' ]
