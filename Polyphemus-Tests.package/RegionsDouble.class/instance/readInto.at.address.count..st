reading
readInto: aBuffer at: anIndex address: anAddress count: aCount

	(regions detect: [ :each | each hasAddress: anAddress ] ifNone: [ ^ false ]) ifNotNil: [ :region |
		aBuffer replaceFrom: anIndex to: anIndex + aCount - 1 with: (region bytesAt: anAddress count: aCount) startingAt: 1 ].
	^ true
