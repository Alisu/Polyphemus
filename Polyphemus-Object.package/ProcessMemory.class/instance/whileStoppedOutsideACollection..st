holding it still
whileStoppedOutsideACollection: aBlock

	"aBlock's value, stopped at a moment no collection moves objects and its classes and special
	objects read whole, looked for until #safeMomentWait has passed; else refused (#91, #113, #31)."

	^ self safeMoment whereItReadsWholeDo: aBlock
