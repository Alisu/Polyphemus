installing
install: aCompilation named: aString in: aReifiedClass

	"A method under a name of our choosing: the image's symbol for it, interned when the
	image has none, and then installed as any other (#25)."

	^ self install: aCompilation under: (self intern: aString) in: aReifiedClass
