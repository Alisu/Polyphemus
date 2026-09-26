tests
testItSignalsAnExternalSemaphoreOfARunningImage

	"As the VM's own threads do it (signalSemaphoreWithIndex): a request, the tide, the flag, and
	the VM signals that semaphore at its next check. What wakes our watcher on any VM."

	| pid reader index |
	pid := self launchTargetRunning: '| dir semaphore |
dir := ' , self spikeDirectory fullName printString , ' asFileReference.
semaphore := Semaphore new.
(dir / ''index'') writeStreamDo: [ :stream | stream print: (Smalltalk registerExternalObject: semaphore) ].
[ semaphore wait. (dir / ''signalled'') ensureCreateFile ] forkAt: 70.
[ [ true ] whileTrue: [ 1000 timesRepeat: [ 3 sqrt ] ] ] forkAt: 40.
(dir / ''started'') ensureCreateFile.
(Delay forSeconds: 120) wait.
Smalltalk exitSuccess'.
	[
	reader := LinuxProcessMemory on: pid.
	index := (self spikeDirectory / 'index') contents trimBoth asNumber.
	self deny: (self spikeDirectory / 'signalled') exists.
	reader whileStopped: [ (SpurWritableProcess on: reader) signalExternalSemaphore: index ].
	self
		assert: (self waitFor: [ (self spikeDirectory / 'signalled') exists ])
		description: 'the VM never signalled it' ] ensure: [
		LibC system: 'kill -9 ' , pid printString.
		reader ifNotNil: [ reader close ] ]
