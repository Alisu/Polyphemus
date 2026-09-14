configuring
mutatesResource

	"Nothing here writes to the image: these tests read processes, stacks, source, names and
	the places code is running. Saying otherwise buys every test its own veryDeepCopy of the
	interpreter and a 59 MB heap, and pays about sixteen seconds for it."

	^ false
