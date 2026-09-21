installing
install: aNewCompilation as: aReifiedMethod of: aReifiedClass insteadOf: anOldCompilation

	"Put code compiled here into the image as that method, in an object of its own, and point
	the class at it. Rung 2 of #25: the code may be any length now, the literals must still be
	the ones the old compilation used."

	| oop |
	anOldCompilation literals = aNewCompilation literals ifFalse: [
		^ self error: 'the new code does not use the same literals' ].
	oop := self allocateLike: aReifiedMethod for: aNewCompilation.
	self fill: oop from: aNewCompilation like: aReifiedMethod.
	self pointAt: oop insteadOf: aReifiedMethod in: aReifiedClass.
	^ oop
