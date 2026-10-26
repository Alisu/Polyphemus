initialization
setChannel: aChannel reader: aProcessMemory identityHash: anInteger startingAt: aMethodSourceOrNil

	"The image is given its helpers, then finds the process, takes it out of its run queue while
	held (#103), and opens a debug session of its own on it: at the method, as written by whoever
	asked runUntil: -- the trap holds the same text."

	channel := aChannel.
	reader := aProcessMemory.
	hash := anInteger.
	channel ask: PolyphemusAgent helpersSource.
	channel ask: '(self at: #hold) value: ' , hash printString , ' value: (' , (aMethodSourceOrNil ifNil: [ 'nil' ]) , '). nil'
