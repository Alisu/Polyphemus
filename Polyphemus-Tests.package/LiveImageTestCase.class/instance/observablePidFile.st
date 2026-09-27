helpers
observablePidFile

	"Where the launched target's pid is written: this class's own directory, as classes that
	launch targets may run at once (#31)."

	| directory |
	directory := self spikeDirectory.
	directory ensureCreateDirectory.
	^ directory / 'observable-target.pid'
