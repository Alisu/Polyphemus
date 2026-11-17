live images
holdProcess: aPid watchedIn: aDirectory until: aMethodSource

	"As holdProcess:watchedIn: then runUntil:, the image read once, where it reaches that method
	(#114). Not reached within a minute, it is held where it got to."

	^ ReifiedDebugSession holding: (HeldImage holding: aPid watchedIn: aDirectory until: aMethodSource)