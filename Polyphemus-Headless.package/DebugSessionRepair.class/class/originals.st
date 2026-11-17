repairing
originals

	"Selector -> (protocol -> source), the same in Pharo 10 to 14 (pharo-project/pharo,
	src/Debugger-Model/DebugSession.class.st)."

	^ Dictionary new
		  at: #isContextPostMortem: put: 'testing' -> 'isContextPostMortem: selectedContext
	"return whether we''re inspecting a frozen exception without a process attached"
	| suspendedContext |
	suspendedContext := interruptedProcess suspendedContext.
	suspendedContext ifNil: [ ^ false ].
	^ (suspendedContext hasContext: selectedContext) not';
		  at: #isLatestContext: put: 'context' -> 'isLatestContext: aContext
  	^ interruptedProcess suspendedContext == aContext';
		  yourself
