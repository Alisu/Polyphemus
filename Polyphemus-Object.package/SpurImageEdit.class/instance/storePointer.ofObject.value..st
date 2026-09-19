editing
storePointer: anIndex ofObject: anOop value: aWord

	"Set slot anIndex, counting from one, of the object at anOop. Refused past its last slot."

	| slots |
	slots := self raw scanner slotsAt: anOop.
	(slots notNil and: [ anIndex between: 1 and: slots ]) ifFalse: [
		^ self error: 'the object at ' , anOop printStringHex , ' has no slot ' , anIndex printString ].
	self storeWord: aWord at: anOop + 8 + (anIndex - 1 * 8)
