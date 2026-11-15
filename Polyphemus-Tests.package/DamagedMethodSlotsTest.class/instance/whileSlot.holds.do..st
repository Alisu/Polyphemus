running
whileSlot: anIndex holds: aWord do: aBlock

	"aBlock's value with that slot of the method overwritten in VMMaker's memory, and the class of
	the victim unreadable; both put back afterwards. What the reading had worked out is
	forgotten both times, so nothing answers from before."

	| before classIndex |
	before := memory fetchPointer: anIndex - 1 ofObject: subject address.
	classIndex := memory classIndexOf: victim address.
	memory setClassIndexOf: victim address to: 16r3FFF00.
	memory storePointerUnchecked: anIndex - 1 ofObject: subject address withValue: aWord.
	reifiedMemory forgetWhatWasRead.
	^ aBlock ensure: [
		  memory storePointerUnchecked: anIndex - 1 ofObject: subject address withValue: before.
		  memory setClassIndexOf: victim address to: classIndex.
		  reifiedMemory forgetWhatWasRead ]
