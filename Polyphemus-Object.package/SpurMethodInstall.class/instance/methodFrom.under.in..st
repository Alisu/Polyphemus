installing
methodFrom: aCompilation under: aSelectorOop in: aReifiedClass

	"A method of the image's own made from code compiled here, with the literals its code names
	made or found there -- in no method dictionary yet."

	| oop |
	oop := self allocate: aCompilation classIndex: reading compiledMethodClassIndex.
	self
		fill: oop
		from: aCompilation
		withLiterals:
		(self literalsFor: aCompilation under: aSelectorOop in: aReifiedClass inside: oop).
	^ oop
