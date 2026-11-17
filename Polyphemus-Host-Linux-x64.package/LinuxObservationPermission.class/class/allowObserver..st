granting
allowObserver: aPid

	"Let exactly one process read this image's memory, and no other. This is the one to
	prefer: it is the difference between telling one person where the key is and leaving the
	door open."

	^ self prctlOption: self setPtracerOption argument: aPid
