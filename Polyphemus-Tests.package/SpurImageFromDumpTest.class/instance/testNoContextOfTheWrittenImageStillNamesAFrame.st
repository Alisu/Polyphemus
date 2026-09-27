tests
testNoContextOfTheWrittenImageStillNamesAFrame

	"An image holds no stack pages, so every frame is a context and no context names a frame
	-- what StackInterpreter>>divorceAllFrames does at snapshot. More than 40 married in the VM 9
	dump, 37 in the VM 10 one."

	| file written |
	self assert: (self contextsNamingAFrameIn: raw) >= 20.

	file := SpurImageFile on: self written.
	written := SpurRawHeap on: file.
	self assert: (self contextsNamingAFrameIn: written) equals: 0.
	file close
