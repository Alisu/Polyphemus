helpers
runnable

	"A process of this image, in its run queue, below the test's priority."

	process := [ [ true ] whileTrue: [ Processor yield ] ] newProcess.
	process priority: Processor userBackgroundPriority.
	process resume.
	^ process
