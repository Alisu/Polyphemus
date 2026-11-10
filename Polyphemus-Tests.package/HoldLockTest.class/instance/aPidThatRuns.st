helpers
aPidThatRuns

	"A process that runs and is not this image: init, or Windows's System."

	^ Smalltalk os isWindows ifTrue: [ 4 ] ifFalse: [ 1 ]
