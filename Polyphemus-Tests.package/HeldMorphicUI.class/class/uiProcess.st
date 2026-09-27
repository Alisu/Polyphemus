accessing
uiProcess

	"Morphic's UI process, which UIManager does not name when the image runs a script."

	^ Process allInstances
		  detect: [ :each | each name = 'Morphic UI Process' and: [ each isTerminated not ] ]
		  ifNone: [ nil ]
