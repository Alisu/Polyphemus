accessing
whyTheListMayBeShort

	"nil where the processes listed are all there are; else, in words, where the walk over the heap
	that lists them stopped, and why: a process past it is not listed (#211). Asked after listing."

	^ memory whereItsListingsStop ifNotNil: [ :walk |
		  'the heap was walked up to 16r' , walk stoppedAt printStringHex , ' only (' , walk reason
		  , '): a process past it is not listed' ]
