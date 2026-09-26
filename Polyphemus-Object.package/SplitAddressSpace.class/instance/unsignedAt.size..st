reading
unsignedAt: anAddress size: aCount

	^ (pieces detect: [ :each | each hasAddress: anAddress ] ifNone: [ ^ nil ])
		  unsignedAt: anAddress
		  size: aCount
