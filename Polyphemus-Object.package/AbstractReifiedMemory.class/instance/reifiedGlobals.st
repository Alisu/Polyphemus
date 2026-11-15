globals
reifiedGlobals

	"The array of global bindings of the image being read: its SystemDictionary keeps
	them in its second slot. What is no object there is refused by name."

	| globals |
	globals := (self reifiedSmalltalk reifiedSlotAt: 1) reifiedSlotAt: 2.
	(globals isKindOf: OOPAbstractObject) ifFalse: [
		^ NotInTheReading signal: 'where the globals are kept there is no array: ' , globals whatItReadsAs ].
	^ globals
