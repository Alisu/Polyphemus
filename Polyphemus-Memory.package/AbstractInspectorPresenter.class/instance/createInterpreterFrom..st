initialization
createInterpreterFrom: anImagePath

	"The image as a started VM would show it: opened as Polyphemus opens one, its initial
	context married to a frame."

	interpreter := Polyphemus interpreterOnImageFile: anImagePath.
	interpreter loadInitialContext
