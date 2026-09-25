tests
testItRefusesAMemoryThatCannotMakeObjects

	"Said when it is made, rather than halfway through an install."

	| reading |
	reading := Polyphemus readImageFile: PharoImageAccessor pathToCandle64Bit.
	self
		should: [
			SpurMethodInstall
				on: reading
				into: (SpurWritableImageFile on: PharoImageAccessor pathToCandle64Bit) ]
		raise: Error
		withExceptionDo: [ :error |
			self assert: (error messageText includesSubstring: 'cannot make objects') ]
