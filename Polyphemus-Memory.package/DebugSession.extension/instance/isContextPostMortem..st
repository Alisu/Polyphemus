*Polyphemus-Memory
isContextPostMortem: selectedContext

	"Whether this is a frozen stack with no process behind it, as a snapshot is: Pharo's version
	asks the interrupted process, which a snapshot session has none of. From hackDebugger."

	| suspendedContext |
	interruptedProcess
		ifNil: [ ^ true ]
		ifNotNil: [
			suspendedContext := interruptedProcess suspendedContext.
			suspendedContext ifNil: [ ^ false ] ].
	^ (suspendedContext hasContext: selectedContext) not
