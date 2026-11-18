holding it still
whileStoppedUnless: aWhyBlock do: aBlock

	"aBlock's value, stopped at a moment aWhyBlock, given the VM's variables, answers nil for:
	looked for until #safeMomentWait has passed, once when its caller holds it stopped. Else
	refused, saying how often it looked and what the last stop saw (#31, #186)."

	^ self safeMoment unless: aWhyBlock do: aBlock
