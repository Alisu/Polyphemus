tests
testAnImageFileWrittenSoundHasNothingToSay

	| path watch |
	path := self writtenCopyPath.
	[
	watch := SpurHeapWatch during: [ (SpurWritableImageFile on: PharoImageAccessor pathToCandle64Bit) writeTo: path ].
	self assert: watch problems isEmpty ] ensure: [ path asFileReference ensureDelete ]
