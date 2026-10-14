tests
testAWatcherIsPutInEvenWhereItsFolderIsNotYet

	"The folder it talks through is made if missing, as START-HERE's example names one nobody
	made: a missing one stopped the hold at its first file."

	| pid folder session |
	pid := self launchStockSpinningTarget.
	folder := self spikeDirectory / 'not-made-yet'.
	folder ensureDeleteAll.
	[
	Polyphemus putAWatcherInto: pid watchedIn: folder.
	session := Polyphemus holdProcess: pid watchedIn: folder.
	self assertTheBusyProcessIsHeldIn: session.
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
