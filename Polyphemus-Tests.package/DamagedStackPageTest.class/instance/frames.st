running
frames

	"The frames of the page in use, newest first, read anew."

	^ (OOPStackPageJournal newWith: reifiedMemory) mostRecentlyUsedPage frames
