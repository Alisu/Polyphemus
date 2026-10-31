helpers
ringLateIn: aPid

	"The observer's ring, sent after the agent ended: what it does depends only on the folder."

	| late |
	late := HeldImage on: aPid watchedIn: self spikeDirectory.
	[ late ring ] ensure: [ (late instVarNamed: #reader) close ]
