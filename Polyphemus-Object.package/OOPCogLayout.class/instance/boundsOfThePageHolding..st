reading
boundsOfThePageHolding: aFramePointer

	"How far the frames from that one may go: to the oldest frame of the stack page the VM
	records it on. Where the VM does not say, or records it on none, a megabyte from it, more
	than any page: a chain that leaves its page is then cut before it wanders the memory (#198)."

	^ [
	  (raw vmVariables pageHolding: aFramePointer)
		  ifNil: [ OOPStackPageBounds within: 16r100000 of: aFramePointer ]
		  ifNotNil: [ :page | OOPStackPageBounds endingAt: page baseFP ] ]
		  on: SpurCannotRead
		  do: [ :unsaid | OOPStackPageBounds within: 16r100000 of: aFramePointer ]
