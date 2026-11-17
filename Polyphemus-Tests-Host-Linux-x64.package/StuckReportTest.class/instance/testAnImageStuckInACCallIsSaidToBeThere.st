tests
testAnImageStuckInACCallIsSaidToBeThere

	"system() waits for its child in wait4: the VM's thread is in C, and no interrupt reaches it."

	| pid report |
	pid := self launchTargetRunning: '| dir | dir := ' , self spikeDirectory fullName printString , ' asFileReference.
(dir / ''started'') ensureCreateFile.
LibC system: ''sleep 600''.
Smalltalk exitSuccess'.
	[
	self assert: (self waitFor: [ (Polyphemus whereIsStuck: pid) mainThread systemCallName = 'wait4' ]).
	report := Polyphemus whereIsStuck: pid.

	self assert: report mainThread isInACCall.
	self assert: (report printString includesSubstring: 'wait4') ] ensure: [
		LibC system: 'pkill -P ' , pid printString , '; kill ' , pid printString ]
