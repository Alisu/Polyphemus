accessing
mainThread

	"The thread whose id is the process's: the one running Smalltalk."

	^ threads detect: [ :each | each id = pid ] ifNone: [ threads first ]
