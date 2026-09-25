live images
holdProcess: aPid watchedIn: aDirectory within: aDuration

	"A debug session on what a running image is busy with, holding it until proceeded: the image
	must run our watcher on aDirectory (PolyphemusAgent watcherSourceWatching:afterwards:).
	Steps are taken there, runUntil: lets it run to a method; proceeding lets it go."

	| image |
	image := HeldImage on: aPid watchedIn: aDirectory.
	image holdWithin: aDuration.
	^ (ReifiedDebugSession
		   named: 'Polyphemus'
		   on: nil
		   startedAt: image process context
		   fixing: nil)
		  stoppedBy: PolyphemusStop heldWhileRunning;
		  holding: image;
		  yourself
