*Polyphemus-Memory
isContextPostMortem: selectedContext

	"Whether we are looking at a frozen stack with no process behind it, which is
	exactly the case for a snapshot: the contexts come from a file, and there is no
	process to resume. Pharo's own version asks the interrupted process, and a
	snapshot session has none.

	From the hackDebugger branch."

	| suspendedContext |
	interruptedProcess
		ifNil: [ ^ true ]
		ifNotNil: [
			suspendedContext := interruptedProcess suspendedContext.
			suspendedContext ifNil: [ ^ false ] ].
	^ (suspendedContext hasContext: selectedContext) not
