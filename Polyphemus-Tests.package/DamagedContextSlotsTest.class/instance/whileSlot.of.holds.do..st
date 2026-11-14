running
whileSlot: anIndex of: aContext holds: aWord do: aBlock

	"aBlock's value with that slot overwritten in VMMaker's memory, and the class of the victim
	unreadable; both put back afterwards. What the reading had worked out is forgotten both
	times, so nothing answers from before."

	| before classIndex |
	before := memory fetchPointer: anIndex - 1 ofObject: aContext address.
	classIndex := memory classIndexOf: victim address.
	memory setClassIndexOf: victim address to: 16r3FFF00.
	memory storePointerUnchecked: anIndex - 1 ofObject: aContext address withValue: aWord.
	reifiedMemory forgetWhatWasRead.
	^ aBlock ensure: [
		  memory storePointerUnchecked: anIndex - 1 ofObject: aContext address withValue: before.
		  memory setClassIndexOf: victim address to: classIndex.
		  reifiedMemory forgetWhatWasRead ]
