frames
isMachineCodeAddress: anAddress

	"In Cog's code zone, where the VM says it is: codeZoneStart to codeZoneEnd from VM 10,
	codeBase to limitAddress on VM 9 (as StuckReport>>codeZoneOf:), or else below the heap."

	codeZone ifNil: [
		codeZone := [ (vmVariables at: 'codeZoneStart') -> (vmVariables at: 'codeZoneEnd') ]
			            on: Error
			            do: [ :e |
				            [ (vmVariables at: 'codeBase') -> (vmVariables at: 'limitAddress') ]
					            on: Error
					            do: [ :e2 | false ] ] ].
	codeZone == false ifTrue: [ ^ anAddress < mappingStart ].
	^ anAddress >= codeZone key and: [ anAddress < codeZone value ]
