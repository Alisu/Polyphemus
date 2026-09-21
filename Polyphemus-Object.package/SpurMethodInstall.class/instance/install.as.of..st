installing
install: aCompilation as: aReifiedMethod of: aReifiedClass

	"Put code compiled here where that method was, with a literal frame of its own: what the
	new code names is found in the image or made there -- blocks among it, which belong to
	the method and so are made after it (#20)."

	| oop |
	oop := self allocateLike: aReifiedMethod for: aCompilation.
	self
		fill: oop
		from: aCompilation
		withLiterals: (self
				 translatedLiteralsOf: aCompilation
				 in: aReifiedClass
				 keeping: aReifiedMethod
				 inside: oop).
	self pointAt: oop insteadOf: aReifiedMethod in: aReifiedClass.
	^ oop
