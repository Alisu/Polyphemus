checking
checkBeforeResuming: aProcessMemory

	(written includes: aProcessMemory) ifFalse: [ ^ self ].
	written remove: aProcessMemory.
	problems addAll: (self class problemsOf: (SpurRawHeap on: aProcessMemory))
