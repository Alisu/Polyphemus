building the fixture
verifyMapping: offsetOf of: aMemory in: anImageFile

	"Each special object slot read from the file and shifted has to be the oop the simulator
	reports: wrong arithmetic would damage some unrelated object and test nothing."

	| delta |
	delta := aMemory reifiedSpecialObjectArray address
	         - (self read: 8 from: anImageFile binaryReadStream at: 24).
	anImageFile binaryReadStreamDo: [ :stream |
		1 to: 6 do: [ :slot |
			| fromFile fromMemory |
			fromFile := self
				            read: 8
				            from: stream
				            at: (offsetOf value: aMemory reifiedSpecialObjectArray address)
					            + (slot * 8).
			fromMemory := (aMemory reifiedSpecialObjectArray reifiedSlotAt: slot) address.
			fromFile + delta = fromMemory ifFalse: [
				^ self error:
					  'cannot locate objects of this image in its file: slot ' , slot printString
					  , ' reads ' , (fromFile + delta) printString , ' where the image has '
					  , fromMemory printString ] ] ]
