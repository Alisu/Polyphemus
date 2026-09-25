live images
holdProcess: aPid watchedIn: aDirectory within: aDuration

	"A debug session on what a running image is busy with, holding it until proceeded: the image
	must run our watcher on aDirectory (PolyphemusAgent watcherSourceWatching:afterwards:).
	Steps are taken there; proceeding lets it go."

	| directory reader channel hash held |
	directory := aDirectory asFileReference.
	reader := LinuxProcessMemory on: aPid.
	(directory / 'interrupted') ensureDelete.
	(directory / 'released') ensureDelete.
	hash := reader whileStopped: [
		        reader
			        storeWord: 1
			        at: ((VMVariables on: reader) addressOf: 'interruptPending').
		        self activeProcessHashIn: reader ].
	(self waitFor: [ (directory / 'interrupted') exists ] within: aDuration) ifFalse: [
		reader close.
		^ self error: 'the image never took the interrupt: is it running the watcher on '
			  , directory fullName , '?' ].
	channel := DirectoryChannel on: directory / 'channel'.
	channel directory ensureDeleteAll.
	(directory / 'do.st')
		ensureDelete;
		writeStreamDo: [ :stream |
			stream nextPutAll: (PolyphemusAgent sourceServing: channel directory) ].
	reader whileStopped: [ self letTheWatcherServe: reader ].
	held := HeldProcess on: channel reader: reader identityHash: hash.
	^ (ReifiedDebugSession named: 'Polyphemus' on: nil startedAt: held topContext fixing: nil)
		  stoppedBy: PolyphemusStop heldWhileRunning;
		  stepWith: held;
		  releaseWith: [
			  held letGo.
			  reader close ];
		  yourself
