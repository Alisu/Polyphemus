fixing
apply: aSource to: aReifiedMethod

	"Compile that source against the image's own class and put it where the method was.
	Answers how it was done, and refuses by name what it cannot do."

	| class old new |
	class := aReifiedMethod oopMethodClass.
	old := self compilationOf: aReifiedMethod for: class.
	new := (reading compileHostSource: aSource for: class) ifNil: [
		       ^ self error: 'that source does not compile' ].
	old first literals = new first literals ifFalse: [
		^ self error:
			  'that change wants literals the image does not hold; only the ones it already has can be used' ].
	(self codeLengthOf: new first) = (self codeLengthOf: old first) ifTrue: [
		edit replaceCodeOfMethodShown: aReifiedMethod from: old first to: new first.
		^ #wroteItWhereItWas ].
	installer ifNil: [
		^ self error: 'that code does not fit where it is, and this memory cannot make room' ].
	installer
		install: new first
		as: aReifiedMethod
		of: class
		insteadOf: old first.
	^ #madeRoomForIt
