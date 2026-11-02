accessing
object

	"The object answered, read from the image as it is now: found by its class and identity hash,
	or made from its value when immediate."

	| memory |
	(which beginsWith: 'integer ') ifTrue: [
		memory := heldReading reading memoryManager.
		^ heldReading reading reifyOop: (memory integerObjectOf: (which allButFirst: 8) asInteger) ].
	(which beginsWith: 'character ') ifTrue: [
		memory := heldReading reading memoryManager.
		^ heldReading reading reifyOop: (memory characterObjectOf: (which allButFirst: 10) asInteger) ].
	which ifEmpty: [ ^ self error: 'an immediate object this observer does not read: ' , printed ].
	^ (heldReading objectOfClassIndex: classIndex hash: which asInteger) ifNil: [
		  self error: 'the image no longer holds ' , printed ]
