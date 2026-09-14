globals
globalNamed: aName

	"The binding of a global in the image being read, or nil. Resolving against our own
	globals instead would answer this image's Object, this image's Smalltalk, and any
	class the two images happen to share by name but not by content."

	^ self globalsByName at: aName asString ifAbsent: [ nil ]
