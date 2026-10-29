frames
codeZone

	"Cog's code zone, start -> limit, where the VM says it is: codeZoneStart to codeZoneEnd from VM
	10, codeBase to limitAddress on VM 9 (as StuckReport>>codeZoneOf:); false where it says nothing."

	^ codeZone ifNil: [
		  codeZone := [ (vmVariables at: 'codeZoneStart') -> (vmVariables at: 'codeZoneEnd') ]
			              on: Error
			              do: [ :e |
				              [ (vmVariables at: 'codeBase') -> (vmVariables at: 'limitAddress') ]
					              on: Error
					              do: [ :e2 | false ] ] ]
