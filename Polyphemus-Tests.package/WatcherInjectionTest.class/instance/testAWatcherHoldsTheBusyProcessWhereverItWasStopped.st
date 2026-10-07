tests
testAWatcherHoldsTheBusyProcessWhereverItWasStopped

	"A hold may stop the loop on its own backward jump, outside any do: it runs: the process
	held is still the busy one, the one forked at 40."

	| pid session |
	pid := self launchStockSpinningTargetLooping: '3 sqrt'.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assertTheBusyProcessIsHeldIn: session.
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
