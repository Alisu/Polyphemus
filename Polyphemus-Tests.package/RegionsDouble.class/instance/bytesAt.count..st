reading
bytesAt: anAddress count: aCount

	^ (regions detect: [ :each | each hasAddress: anAddress ] ifNone: [ ^ nil ]) bytesAt: anAddress count: aCount
