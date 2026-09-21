installing
install: aCompilation under: aSelectorOop in: aReifiedClass

	"A method the class never had, under a selector the image holds, with the literals its
	code names made or found there."

	| oop |
	oop := self allocate: aCompilation classIndex: reading compiledMethodClassIndex.
	self
		fill: oop
		from: aCompilation
		withLiterals:
		(self literalsFor: aCompilation under: aSelectorOop in: aReifiedClass inside: oop).
	self addTo: aReifiedClass selector: aSelectorOop method: oop.
	^ oop
