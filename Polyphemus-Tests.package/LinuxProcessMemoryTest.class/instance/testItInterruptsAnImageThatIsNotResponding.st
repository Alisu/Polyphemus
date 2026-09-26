tests
testItInterruptsAnImageThatIsNotResponding

	"#24: a semaphore signalled from outside, as the VM's own threads do it, wakes a process
	above the one that will not yield -- how a wedged image is stopped where we want it. The
	VM answers the request it was given."

	| pid reader requests |
	pid := self launchSpinningTarget.
	[
	reader := LinuxProcessMemory on: pid.
	requests := (VMVariables on: reader) at: 'signalRequests'.
	self deny: (LinuxProcessMemory unchecked: pid) isQuiet.

	reader whileStopped: [
		(SpurWritableProcess on: reader) signalExternalSemaphore: self watcherSemaphoreIndex ].

	self
		assert: (self waitFor: [ (self spikeDirectory / 'interrupted') exists ])
		description: 'the image never took the interrupt'.
	self
		assert: (reader bytesAt: requests + (self watcherSemaphoreIndex - 1 * 8) count: 4)
		equals: (reader bytesAt: requests + (self watcherSemaphoreIndex - 1 * 8) + 4 count: 4) ]
		ensure: [
			LibC system: 'kill -9 ' , pid printString.
			reader ifNotNil: [ reader close ] ]
