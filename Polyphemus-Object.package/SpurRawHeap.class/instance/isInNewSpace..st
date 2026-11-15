frames
isInNewSpace: anAddress

	"Where the VM says new space lies; false in a memory where no heap is found."

	^ [ anAddress >= self newSpaceStart and: [ anAddress < self newSpaceLimit ] ]
		  on: PolyphemusError
		  do: [ :refusal | false ]
