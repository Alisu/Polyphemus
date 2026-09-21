fixing
apply: aSource to: aReifiedMethod

	"Compile that source against the image's own class and put it where the method was: over
	it when the code fits and names the same literals, and in a method of its own otherwise.
	Answers how it was done, and refuses by name what it cannot do."

	| class old new |
	class := aReifiedMethod oopMethodClass.
	old := self compilationOf: aReifiedMethod for: class.
	new := (reading compileHostSource: aSource for: class) ifNil: [
		       ^ self error: 'that source does not compile' ].
	(old first literals = new first literals and: [
		 (self codeLengthOf: new first) = (self codeLengthOf: old first) ]) ifTrue: [
		edit replaceCodeOfMethodShown: aReifiedMethod from: old first to: new first.
		^ #wroteItWhereItWas ].
	installer ifNil: [
		^ self error: 'that code does not fit where it is, and this memory cannot make room' ].
	installer install: new first as: aReifiedMethod of: class.
	^ #madeRoomForIt
