*Polyphemus-Memory
isLatestContext: aContext

	"A snapshot session has no interrupted process: the newest context is the one the
	session was started at."

	interruptedProcess ifNil: [ ^ aContext == self context ].
	^ interruptedProcess suspendedContext == aContext
