initialization
setChannel: aChannel identityHash: anInteger

	"The image finds the process, suspends it, and opens a debug session of its own on it."

	channel := aChannel.
	hash := anInteger.
	channel ask: '| found |
found := Process allInstances select: [ :each | each basicIdentityHash = ' , hash printString , ' ].
found size = 1 ifFalse: [ self error: found size printString , '' processes have that hash'' ].
self at: #process put: found first.
found first suspend.
self at: #session put: (DebugSession named: ''Polyphemus'' on: found first startedAt: found first suspendedContext).
nil'
