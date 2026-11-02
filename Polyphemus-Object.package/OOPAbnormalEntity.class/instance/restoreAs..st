repairing
restoreAs: aGuess
	"Writes the header aGuess says this object had, so that it reads as such an object again
	(#139)."

	memory memoryManager
		long64At: address
		put: (memory memoryManager headerForSlots: aGuess numSlots format: aGuess format classIndex: aGuess classIndex)
