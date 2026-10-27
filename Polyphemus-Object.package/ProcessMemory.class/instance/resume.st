holding it still
resume

	"Let it run again, what was read forgotten. Answers whether it runs."

	self forgetWhatWasRead.
	self resumeItsThreads.
	^ self isStopped not
