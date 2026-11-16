reading
codeZoneOf: aProcess

	"Where Cog keeps machine code, as the VM says: codeZoneStart to codeZoneEnd from VM 10,
	codeBase to limitAddress on VM 9. nil when its variables cannot be read."

	| variables |
	variables := VMVariables on: aProcess.
	^ (VMVariables whereTheVMSays: [ (variables at: 'codeZoneStart') -> (variables at: 'codeZoneEnd') ]) ifNil: [
		  VMVariables whereTheVMSays: [ (variables at: 'codeBase') -> (variables at: 'limitAddress') ] ]
