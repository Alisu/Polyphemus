accessing
highestReadableLevel

	"The highest readable rung -- not simply the one below the first failure, since a local rung
	can fail (a running heap's freeSpace) with the ones above still readable."

	^ (self levels select: [ :level | self canRead: level ])
		  ifEmpty: [ nil ]
		  ifNotEmpty: [ :readable | readable last ]
