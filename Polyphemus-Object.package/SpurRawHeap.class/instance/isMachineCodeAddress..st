frames
isMachineCodeAddress: anAddress

	"In Cog's code zone, or else below the heap where the VM does not say where it is."

	self codeZone == false ifTrue: [ ^ anAddress < mappingStart ].
	^ anAddress >= self codeZone key and: [ anAddress < self codeZone value ]
