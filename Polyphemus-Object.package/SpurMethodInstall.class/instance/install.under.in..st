installing
install: aCompilation under: aSelectorOop in: aReifiedClass

	"A method the class never had, under a selector the image already holds. Rung 3 of #25:
	a symbol of its own is the step after this one."

	| oop |
	oop := self allocate: aCompilation classIndex: reading compiledMethodClassIndex.
	self
		fill: oop
		from: aCompilation
		withLiterals: (self literalsFor: aCompilation under: aSelectorOop in: aReifiedClass).
	self addTo: aReifiedClass selector: aSelectorOop method: oop.
	^ oop
