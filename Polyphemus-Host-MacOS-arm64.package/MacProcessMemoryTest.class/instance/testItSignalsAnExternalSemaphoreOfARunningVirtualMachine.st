tests
testItSignalsAnExternalSemaphoreOfARunningVirtualMachine

	"As the VM's own threads do it (signalSemaphoreWithIndex), through the task port of a stock
	VM: the VM signals that semaphore at its next check. Wakes an image with nothing injected."

	| pid reader dir index |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	dir := PolyphemusEdition current scratch / 'mac-semaphore'.
	dir ensureDeleteAll.
	dir ensureCreateDirectory.
	pid := self launchTargetRunning: '| dir semaphore |
dir := ' , dir fullName printString , ' asFileReference.
semaphore := Semaphore new.
(dir / ''index'') writeStreamDo: [ :stream | stream print: (Smalltalk registerExternalObject: semaphore) ].
[ semaphore wait. (dir / ''signalled'') ensureCreateFile ] forkAt: 70.
[ [ true ] whileTrue: [ (1 to: 1000) do: [ :each | 3 sqrt ] ] ] forkAt: 30.
(Delay forSeconds: 60) wait.
Smalltalk exitSuccess'.
	[
	reader := MacProcessMemory on: pid.
	index := (dir / 'index') contents trimBoth asNumber.
	self deny: (dir / 'signalled') exists.
	reader whileStopped: [ (SpurWritableProcess on: reader) signalExternalSemaphore: index ].
	self
		assert: ((1 to: 50) anySatisfy: [ :each |
				 (dir / 'signalled') exists or: [ (Delay forMilliseconds: 100) wait. false ] ])
		description: 'the VM never signalled it' ] ensure: [
		LibC system: 'kill ' , pid printString.
		reader ifNotNil: [ reader close ] ]
