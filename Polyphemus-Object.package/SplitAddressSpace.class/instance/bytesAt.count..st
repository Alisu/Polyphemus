reading
bytesAt: anAddress count: aCount

	"All of them, from the one piece holding them, or nothing."

	^ (pieces detect: [ :each | each hasAddress: anAddress ] ifNone: [ ^ nil ])
		  bytesAt: anAddress
		  count: aCount
