accessing
edenBounds

	"Eden's start -> limit as the VM states them, or, on a VM naming no eden (macOS), from where
	the higher survivor space ends to where new space ends (newSpaceEnd; VM 9's newSpaceLimit)."

	^ [ self boundsOf: 'eden' ]
		  on: SpurCannotRead
		  do: [ :e |
			  e reason = #theVMLibraryHasNoSuchSymbol ifFalse: [ e pass ].
			  ((self boundsOf: 'pastSpace') value max: (self boundsOf: 'futureSpace') value)
			  -> ([ self at: 'newSpaceEnd' ] on: SpurCannotRead do: [ :f | self at: 'newSpaceLimit' ]) ]
