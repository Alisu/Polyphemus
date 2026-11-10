test-color
testChangeColorsBackToDefault
	
	| selectedOop |
	selectedOop := self newZeroSizedObject.
	self updateSpaces.
	
	newSpace allReferencersOf: (newSpace oopForAddress: selectedOop) model.
	self deny: newSpace colorProvider class equals: DefaultColorProvider.

	newSpace updateColorProviderTo: newSpace defaultColorProvider.
	self assert: newSpace colorProvider class equals: DefaultColorProvider