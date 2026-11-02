running
heldAtTickOf: aPid
	"A session holding the counter of aPid in Counter>>tick:."

	| session |
	Polyphemus putAWatcherInto: aPid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: aPid watchedIn: self spikeDirectory.
	session runUntil: 'Counter >> #tick:'.
	^ session
