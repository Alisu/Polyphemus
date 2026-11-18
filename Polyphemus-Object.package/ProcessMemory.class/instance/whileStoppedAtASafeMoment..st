holding it still
whileStoppedAtASafeMoment: aBlock

	"aBlock's value on a copy of its heap and the reader holding it still, at a moment to write at:
	looked for until #safeMomentWait has passed, else refused saying what the last stop saw (#91)."

	^ self safeMoment toWriteDo: aBlock
