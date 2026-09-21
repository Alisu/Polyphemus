installing
install: aCompilation as: aReifiedMethod of: aReifiedClass

	"Put code compiled here where that method was, with a literal frame of its own: what the
	new code names is found in the image or made there, so the frame need not be the old
	one's -- an edit reorders it as soon as it inlines anything (#20)."

	| oop |
	oop := self allocateLike: aReifiedMethod for: aCompilation.
	self
		fill: oop
		from: aCompilation
		withLiterals:
		(self translatedLiteralsOf: aCompilation in: aReifiedClass keeping: aReifiedMethod).
	self pointAt: oop insteadOf: aReifiedMethod in: aReifiedClass.
	^ oop
