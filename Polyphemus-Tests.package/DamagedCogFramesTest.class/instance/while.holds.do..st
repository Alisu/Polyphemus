running
while: anAddress holds: aWord do: aBlock

	"aBlock's value with the core answering aWord at that address, which is checked: a patch the
	reading does not see would test nothing. What the reading had worked out is forgotten before
	and after, so nothing answers from before."

	self class patches at: anAddress put: aWord.
	memory forgetWhatWasRead.
	^ [
	  self assert: (memory vmLayout wordAt: anAddress) equals: aWord.
	  aBlock value ] ensure: [
		  self class patches removeKey: anAddress.
		  memory forgetWhatWasRead ]
