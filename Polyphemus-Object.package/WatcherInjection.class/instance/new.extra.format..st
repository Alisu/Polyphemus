making
new: aClassName extra: aCount format: aFormat

	"An instance of that class of the image's, its named slots and aCount more, all nil."

	| class slots |
	class := reading oopClassNamed: aClassName.
	slots := class allInstVarNames size + aCount.
	^ installer memory allocateSlots: slots format: aFormat classIndex: class oopHash filledWith: installer nilOop
