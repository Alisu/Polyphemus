accessing
newSpaceEnd

	"Where new space ends: newSpaceEnd, in VM 10's memory map, or VM 9's newSpaceLimit."

	^ [ self at: 'newSpaceEnd' ]
		  on: SpurCannotRead
		  do: [ :e |
			  e reason = #theVMLibraryHasNoSuchSymbol ifFalse: [ e pass ].
			  self at: 'newSpaceLimit' ]
