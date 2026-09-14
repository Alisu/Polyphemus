globals
reifiedGlobals

	"The array of global bindings of the image being read: its SystemDictionary keeps
	them in its second slot."

	^ (self reifiedSmalltalk reifiedSlotAt: 1) reifiedSlotAt: 2
