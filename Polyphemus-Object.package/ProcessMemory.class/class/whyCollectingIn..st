holding it still
whyCollectingIn: someVMVariables

	"Why a write into the stopped image could be lost to a collection, or lose an object to one:
	objects moving (a scavenge, a compaction) or being marked. nil when neither (#163, risk 4)."

	| phase marking |
	phase := someVMVariables at: 'gcPhaseInProgress'.
	phase = 0 ifFalse: [ ^ 'collecting garbage (gcPhaseInProgress ' , phase printString , ')' ].
	marking := [ someVMVariables at: 'marking' ]
		           on: SpurCannotRead
		           do: [ :error | error reason = #theVMLibraryHasNoSuchSymbol ifTrue: [ 0 ] ifFalse: [ error pass ] ].
	marking = 0 ifFalse: [ ^ 'marking objects for a full collection' ].
	^ nil
