reading
readThreadsOf: aProcess notingRunning: earlierThreads

	"Each thread of the process, the main one first; one that ran before a stop keeps saying so."

	^ self subclassResponsibility
