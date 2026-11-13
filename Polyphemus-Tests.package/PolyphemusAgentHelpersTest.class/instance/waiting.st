helpers
waiting

	"A process of this image waiting on a semaphore: made above the test's priority, so it is there when this answers."

	process := [ Semaphore new wait ] newProcess.
	process priority: Processor activePriority + 1.
	process resume.
	^ process
