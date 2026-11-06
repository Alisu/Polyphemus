frames
isInNewSpace: anAddress

	"Where the VM says new space lies; false where it does not say."

	^ [ anAddress >= self newSpaceStart and: [ anAddress < self newSpaceLimit ] ]
		  on: Error
		  do: [ :e | false ]
