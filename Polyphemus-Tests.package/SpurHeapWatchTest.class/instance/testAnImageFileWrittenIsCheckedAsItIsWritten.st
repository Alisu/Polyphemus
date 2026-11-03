tests
testAnImageFileWrittenIsCheckedAsItIsWritten

	"#141: once the test ends, the file it wrote may be gone; it is read back as it is written."

	| path watch |
	path := self writtenCopyPath.
	[
	watch := SpurHeapWatch during: [
		         | copy |
		         copy := SpurWritableImageFile on: PharoImageAccessor pathToCandle64Bit.
		         copy storeBytes: (ByteArray new: 64) at: copy raw heapStart.
		         copy writeTo: path ].
	self assert: watch problems notEmpty ] ensure: [ path asFileReference ensureDelete ]
