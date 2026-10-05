reading
readThreadsOf: aProcess notingRunning: earlierThreads

	"Each task of the process, the main thread first; a thread that was running before it was
	stopped keeps saying so."

	| files |
	files := aProcess mappedFiles.
	^ ((aProcess pathFor: 'task') asFileReference directories collect: [ :each |
		   | thread |
		   thread := StuckThread from: each files: files.
		   (earlierThreads anySatisfy: [ :old | old id = thread id and: [ old wasRunning ] ]) ifTrue: [
			   thread beenRunning ].
		   thread ]) asSortedCollection: [ :a :b | a id = pid or: [ b id ~= pid and: [ a id < b id ] ] ]
