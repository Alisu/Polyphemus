initialization
setChannel: aChannel reader: aProcessMemory identityHash: anInteger startingAt: aMethodSourceOrNil

	"The image is given its helpers, then finds the process, takes it out of its run queue while
	held (#103), and opens a debug session of its own on it: at the method, as written by whoever
	asked runUntil: -- the trap holds the same text."

	channel := aChannel.
	hash := anInteger.
	heldReading := HeldReading on: aProcessMemory identityHash: anInteger.
	self request: PolyphemusAgent helpersSource.
	[ self request: '(self at: #hold) value: ' , hash printString , ' value: (' , (aMethodSourceOrNil ifNil: [ 'nil' ]) , '). nil' ]
		on: PolyphemusChannelError
		do: [ :error |
			(error messageText includesSubstring: ' 0 processes have that hash') ifFalse: [ error pass ].
			ProcessEndedBeforeHeld signal: 'the process running when the image was stopped had ended before it was held' ].
	(self request: '(self at: #processSlot)') ifNotNil: [ :slot | heldReading lookFirstInExternalSlot: slot asNumber ]
