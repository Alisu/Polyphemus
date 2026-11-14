running
while: anAddress holds: aWord do: aBlock

	"aBlock's value with that word of the stack pages overwritten, and put back afterwards; what
	the reading had worked out is forgotten both times, so nothing answers from before."

	| pages before |
	pages := reifiedMemory interpreter stackPages.
	before := pages unsignedLongAt: anAddress.
	pages unsignedLongAt: anAddress put: aWord.
	reifiedMemory forgetWhatWasRead.
	^ aBlock ensure: [
		  pages unsignedLongAt: anAddress put: before.
		  reifiedMemory forgetWhatWasRead ]
