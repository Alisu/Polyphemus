tests
testAnEditAimedAtWhatTheReadingShowsLandsInTheFile

	"Rung 0 of #25: aim an edit at an object the reading shows -- what an inspector has in
	front of it -- and it lands in the file, at the address the file uses rather than the one
	VMMaker loaded the image at."

	| reading edit specials file word |
	reading := Polyphemus readImageFile: PharoImageAccessor pathToCandle64Bit.
	edit := (SpurImageEdit on: PharoImageAccessor pathToCandle64Bit) reading: reading.
	specials := reading reifiedSpecialObjectArray.
	self assert: specials address ~= (edit addressOf: specials).

	edit store: 42 inSlot: 1 ofObjectShown: specials.
	edit writeTo: written.

	file := SpurImageFile on: written.
	word := file unsignedAt: file specialObjectsOop + 8 size: 8.
	file close.
	self assert: word equals: 42 * 8 + 1.
	self assert: (Polyphemus readabilityOfImageFile: written) isFullyReadable
