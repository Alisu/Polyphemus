reading
bytesAt: anAddress count: aCount

	bytesAsked := (bytesAsked ifNil: [ 0 ]) + 1.
	^ (regions detect: [ :each | each hasAddress: anAddress ] ifNone: [ ^ nil ]) bytesAt: anAddress count: aCount
