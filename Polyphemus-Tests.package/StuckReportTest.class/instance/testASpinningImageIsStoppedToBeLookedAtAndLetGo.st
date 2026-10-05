tests
testASpinningImageIsStoppedToBeLookedAtAndLetGo

	"A running thread says nothing of where it is; stopped, it gives its pc. The report says it
	stopped the image, and the image runs on."

	| pid report |
	pid := self launchSpinningTarget.
	[
	report := Polyphemus whereIsStuck: pid.

	self assert: report stoppedToLook.
	self assert: report mainThread wasRunning.
	self assert: report mainThread pc notNil.
	self assert: report mainThread location notEmpty.
	self deny: (LinuxProcessMemory on: pid) isStopped.
	self assert: (report printString includesSubstring: 'stopped for a moment') ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
