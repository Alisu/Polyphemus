tests
testAVirtualMachineRunsTheWrittenImage

	"What writing one is for: a virtual machine loads the image and goes on running it. It
	answers nothing, being where the dumped machine was -- a process waiting."

	| copy pid |
	copy := self runDirectory / 'from-dump.image'.
	copy ensureDelete.
	(self runDirectory / 'crash.dmp') ensureDelete.
	self written copyTo: copy.
	pid := self launch: copy.
	[
	self
		assert: (self waitUntil: [ self imageIsLoadedBy: (LinuxProcessMemory unchecked: pid) ])
		description: 'the machine never loaded the image'.
	(Delay forSeconds: 3) wait.
	self
		assert: ((LinuxProcessMemory unchecked: pid) commandLine includesSubstring: copy fullName)
		description: 'the machine stopped running the image'.
	self deny: (self runDirectory / 'crash.dmp') exists ] ensure: [
		LibC system: 'kill ' , pid printString ]
