tests
testTheBoundOfClassIndexesReadFromTheFileIsTheSimulatorsOwn

	"#207: the ladder refuses an image file with a class index past the class table because
	VMMaker asserts on one. The bound read from the file's bytes is the one VMMaker counted when
	it loaded the same file: 24 pages of 1024 on this image."

	| file |
	file := SpurImageFile on: (PharoImageAccessor pathToPharo: 12) asFileReference.
	[
	| heap |
	heap := SpurRawHeap on: file.
	self
		assert: (heap scanner classIndexLimitFrom: heap heapStart)
		equals: memory numClassTablePages * memory classTablePageSize ] ensure: [ file close ]
