running
oldestFrame

	"The oldest frame of the page in use, read anew: it runs a method."

	^ (OOPStackPageJournal newWith: reifiedMemory) mostRecentlyUsedPage frames last
