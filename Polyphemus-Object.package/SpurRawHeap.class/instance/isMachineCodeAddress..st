frames
isMachineCodeAddress: anAddress

	"In Cog's code zone: where the VM says it is (VM 10's memory map), or else below the heap,
	where VM 9 keeps it."

	codeZone ifNil: [
		codeZone := [ (vmVariables at: 'codeZoneStart') -> (vmVariables at: 'codeZoneEnd') ]
			            on: Error
			            do: [ :e | false ] ].
	codeZone == false ifTrue: [ ^ anAddress < mappingStart ].
	^ anAddress >= codeZone key and: [ anAddress < codeZone value ]
