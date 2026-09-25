initialization
setChannel: aChannel reader: aProcessMemory identityHash: anInteger

	"The image finds the process and opens a debug session of its own on it. It is left in its
	queue: the agent holding the image keeps it from running, and a reading finds it there."

	channel := aChannel.
	reader := aProcessMemory.
	hash := anInteger.
	channel ask: '| found |
found := Process allInstances select: [ :each | each basicIdentityHash = ' , hash printString , ' ].
found size = 1 ifFalse: [ self error: found size printString , '' processes have that hash'' ].
self at: #process put: found first.
self at: #session put: (DebugSession named: ''Polyphemus'' on: found first startedAt: found first suspendedContext).
nil'
