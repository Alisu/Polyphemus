tests
testTheDebuggerFixesAMethodOfTheRunningImage

	"Accepted in the code pane, as the debugger does it, a method of a running image is fixed
	there (#20): the process that loops on SmallInteger>>even, which the machine compiled, stops
	looping once let go."

	| pid session |
	pid := self launchWarmedSpinningTarget.
	[
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	session runUntil: 'SmallInteger >> #even'.
	self assert: session interruptedContext selector equals: #even.
	self assert: (session
			 recompileMethodTo: 'even ^ false'
			 inContext: session interruptedContext
			 notifying: nil).
	"run until let the image go once already, which left these behind"
	(self spikeDirectory / 'released') ensureDelete.
	(self spikeDirectory / 'answer') ensureDelete.
	session resume.
	self
		assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
		description: 'it never let go'.
	self assert: (self spikeDirectory / 'answer') contents trimBoth equals: 'false'.
	self
		assert: (self waitFor: [ (LinuxProcessMemory unchecked: pid) isQuiet ])
		description: 'it went on running away' ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
