accessing
edenStart

	"Where eden starts: as the VM states it, or, on a VM naming no eden (macOS), where the higher
	survivor space ends (SpurGenerationScavenger>>newSpaceStart:newSpaceBytes:survivorBytes:)."

	^ [ (self boundsOf: 'eden') key ]
		  on: SpurCannotRead
		  do: [ :e |
			  e reason = #theVMLibraryHasNoSuchSymbol ifFalse: [ e pass ].
			  (self boundsOf: 'pastSpace') value max: (self boundsOf: 'futureSpace') value ]
