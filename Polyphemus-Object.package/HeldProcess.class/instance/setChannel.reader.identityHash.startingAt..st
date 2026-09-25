initialization
setChannel: aChannel reader: aProcessMemory identityHash: anInteger startingAt: aMethodSourceOrNil

	"The image finds the process and opens a debug session of its own on it. It is left in its
	queue: the agent holding the image keeps it from running, and a reading finds it there."

	channel := aChannel.
	reader := aProcessMemory.
	hash := anInteger.
	channel ask: '| found start method |
found := Process allInstances select: [ :each | each basicIdentityHash = ' , hash printString , ' ].
found size = 1 ifFalse: [ self error: found size printString , '' processes have that hash'' ].
self at: #process put: found first.
start := found first suspendedContext.
' , (aMethodSourceOrNil
	 ifNil: [ '' ]
	 ifNotNil: [ :source | 'method := ' , source , '.
start := (start findContextSuchThat: [ :each | each method selector == method selector and: [ each method methodClass == method methodClass ] ]) ifNil: [ start ].
' ]) , 'self at: #session put: (DebugSession named: ''Polyphemus'' on: found first startedAt: start).
nil'
