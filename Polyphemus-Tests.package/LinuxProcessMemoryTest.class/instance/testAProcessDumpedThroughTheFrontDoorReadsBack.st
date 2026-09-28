tests
testAProcessDumpedThroughTheFrontDoorReadsBack

	"#66: a dump of a running image, written while it is quiet, to a path given as a string, reads
	back through Polyphemus readCoreDump:."

	| pid path |
	pid := self launchObservableTarget.
	path := (self spikeDirectory / 'front-door.core') fullName.
	[
	Polyphemus dumpProcess: pid to: path.
	self assert: (Polyphemus readCoreDump: path) allReifiedProcesses notEmpty ] ensure: [
		LibC system: 'kill ' , pid printString.
		path asFileReference ensureDelete ]
