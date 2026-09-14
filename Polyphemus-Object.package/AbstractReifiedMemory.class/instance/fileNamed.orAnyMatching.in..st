sources
fileNamed: aName orAnyMatching: aPattern in: aDirectory

	"The file belonging to this image if it is there, otherwise any file of that kind,
	which is what a directory holding a single image looks like."

	^ (aDirectory / aName) exists
		  ifTrue: [ aDirectory / aName ]
		  ifFalse: [
			  (aDirectory filesMatching: aPattern)
				  ifEmpty: [ nil ]
				  ifNotEmpty: [ :all | all first ] ]
