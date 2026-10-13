reading
readThreadsOf: aProcess notingRunning: earlierThreads

	"Each thread, the main thread first (task_threads); a thread that was running before it was
	stopped keeps saying so."

	| files |
	files := aProcess mappedFiles.
	^ aProcess threadPorts collect: [ :each |
		  | thread |
		  thread := MacStuckThread of: each in: aProcess files: files codeZone: codeZone.
		  (earlierThreads anySatisfy: [ :old | old id = thread id and: [ old wasRunning ] ]) ifTrue: [
			  thread beenRunning ].
		  thread ]
