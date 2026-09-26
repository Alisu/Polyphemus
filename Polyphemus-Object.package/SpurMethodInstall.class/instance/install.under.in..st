installing
install: aCompilation under: aSelectorOop in: aReifiedClass

	"A method the class never had, under a selector the image holds, with the literals its
	code names made or found there."

	| oop |
	oop := self methodFrom: aCompilation under: aSelectorOop in: aReifiedClass.
	self addTo: aReifiedClass selector: aSelectorOop method: oop.
	^ oop
