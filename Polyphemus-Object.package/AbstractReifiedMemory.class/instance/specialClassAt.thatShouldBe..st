initialization
specialClassAt: anIndex thatShouldBe: aName

	"The address special object anIndex holds, read for its class index before anything is
	reified; refused by name where it reads as no class (#207)."

	| class |
	class := memory fetchPointer: anIndex - 1 ofObject: memory specialObjectsOop.
	(self classIsReadableAt: class) ifFalse: [
		^ SpurCannotRead new
			  level: #specialObjects reason: #aSpecialObjectIsNoClass;
			  detail: 'special object ' , anIndex printString , ', ' , aName , ', holds ' , (class printStringRadix: 16);
			  signal ].
	^ class
