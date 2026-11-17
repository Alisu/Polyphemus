live images
holdProcess: aPid watchedIn: aDirectory within: aDuration

	"A debug session on what a running image is busy with, holding it until proceeded: the image
	must run our watcher on aDirectory (PolyphemusAgent watcherSourceWatching:afterwards:).
	Steps are taken there, runUntil: lets it run to a method; proceeding lets it go."

	^ ReifiedDebugSession holding: (HeldImage holding: aPid watchedIn: aDirectory within: aDuration)