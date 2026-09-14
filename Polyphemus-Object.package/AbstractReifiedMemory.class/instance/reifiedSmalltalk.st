globals
reifiedSmalltalk

	"The Smalltalk of the image being read, not ours."

	^ self reifiedSpecialObjectArray reifiedSlotAt: self smalltalkGlobalsSlot
