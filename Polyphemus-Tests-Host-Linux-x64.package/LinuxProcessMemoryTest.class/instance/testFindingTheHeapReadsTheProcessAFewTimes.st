tests
testFindingTheHeapReadsTheProcessAFewTimes

	"Each read of a process is a system call on macOS. Finding the heap read the word before a
	mapping's end again for every region of the process, at each mapping it followed (#122)."

	| pid reader |
	pid := self launchSpinningTarget.
	[
	reader := CountingProcessMemory on: pid.
	reader whileStopped: [ SpurRawHeap on: reader ].
	self assert: reader reads < 50 description: [ reader reads printString , ' reads' ] ] ensure: [
		reader ifNotNil: [ reader close ].
		LibC system: 'kill -9 ' , pid printString ]
