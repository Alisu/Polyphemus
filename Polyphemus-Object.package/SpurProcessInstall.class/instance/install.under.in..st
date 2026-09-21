installing
install: aCompilation under: aSelectorOop in: aReifiedClass

	"A method the class did not have, made in the running image and put in its dictionary.
	Its literals are its selector and its class's binding, and whatever can be made without
	asking the image for room -- anything else is refused."

	| oop |
	oop := self allocateFor: aCompilation.
	self fill: oop from: aCompilation under: aSelectorOop in: aReifiedClass.
	self addTo: aReifiedClass selector: aSelectorOop method: oop.
	^ oop
