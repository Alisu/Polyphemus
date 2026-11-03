holding it still
resume

	"Let it run again, what was read forgotten. Answers whether it runs. Written while stopped, its
	heap is checked first when a test watches (#141)."

	SpurHeapWatch checkBeforeResuming: self.
	self forgetWhatWasRead.
	self resumeItsThreads.
	^ self isStopped not
