reading
cogMethodAddressOf: aMethodAddress

	"Where the CogMethod Cog compiled of the method at that address is: what its header slot
	holds once jitted. nil when the slot holds the header itself, or no address of the code zone."

	| header |
	header := self wordAt: aMethodAddress + memory wordSize.
	^ ((header bitAnd: 1) = 0 and: [ raw isMachineCodeAddress: header ]) ifTrue: [ header ]