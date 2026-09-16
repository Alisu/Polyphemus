accessing
highestReadableLevel

	"The highest rung that can be read -- which is not simply the one below the first
	failure, now that a rung can fail without stopping the ones above it. A heap read while
	it is still running fails `freeSpace` almost by definition, and its classes are perfectly
	readable regardless."

	^ (self levels select: [ :level | self canRead: level ])
		  ifEmpty: [ nil ]
		  ifNotEmpty: [ :readable | readable last ]
