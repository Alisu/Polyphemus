making
new: aClassName extra: aCount format: aFormat

	"An instance of that class of the image's, its named slots and aCount more, all nil."

	| class slots oop |
	class := reading oopClassNamed: aClassName.
	slots := class allInstVarNames size + aCount.
	oop := installer memory allocateSlots: slots format: aFormat classIndex: class oopHash.
	0 to: slots - 1 do: [ :each |
		installer memory storePointer: each ofObject: oop withValue: installer nilOop ].
	^ oop
