tests
testTheOopTabLetsSlotsBeTypedInOnlyWithAnEditor

	| reading specials valueColumn |
	reading := Polyphemus readImageFile: PharoImageAccessor pathToCandle64Bit.
	specials := reading reifiedSpecialObjectArray.
	valueColumn := [ (specials inspectionItems: SpPresenter new) columns second ].
	self deny: valueColumn value isEditable.
	reading editor: (SpurEdit on: (SpurWritableImageFile on: PharoImageAccessor pathToCandle64Bit) reading: reading).
	self assert: valueColumn value isEditable
