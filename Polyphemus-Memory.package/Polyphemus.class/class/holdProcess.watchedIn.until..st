live images
holdProcess: aPid watchedIn: aDirectory until: aMethodSource

	"As holdProcess:watchedIn: then runUntil:, the image read once, where it reaches that method
	(#114). Not reached within a minute, it is held where it got to."

	| image |
	image := HeldImage holding: aPid watchedIn: aDirectory within: 1 minute.
	image runUntil: aMethodSource within: 1 minute.
	^ (ReifiedDebugSession
		   named: 'Polyphemus'
		   on: nil
		   startedAt: image process context
		   fixing: nil)
		  stoppedBy: PolyphemusStop heldWhileRunning;
		  holding: image;
		  yourself
