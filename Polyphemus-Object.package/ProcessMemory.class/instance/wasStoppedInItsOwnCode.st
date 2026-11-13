testing
wasStoppedInItsOwnCode

	"Whether its VM was stopped in its own code and not at rest: an allocation of its own may be
	half done, a chunk off its free list and not yet an object (#165). False where it does not say."

	^ [ self isQuiet not and: [ (VMVariables on: self) wasRunningMachineCode == false ] ]
		  on: Error
		  do: [ :error | false ]
