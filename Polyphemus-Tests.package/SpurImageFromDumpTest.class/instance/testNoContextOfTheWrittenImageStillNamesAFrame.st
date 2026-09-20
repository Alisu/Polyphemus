tests
testNoContextOfTheWrittenImageStillNamesAFrame

	"An image holds no stack pages, so every frame is a context and no context names a frame
	-- what StackInterpreter>>divorceAllFrames does at snapshot."

	| file written |
	self assert: (self contextsNamingAFrameIn: raw) > 40.

	file := SpurImageFile on: self written.
	written := SpurRawHeap on: file.
	self assert: (self contextsNamingAFrameIn: written) equals: 0.
	file close
