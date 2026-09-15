reading
bytesAt: anAddress count: aCount

	"All of them or nothing, the way a dump answers: a short answer that looks whole is the
	dangerous kind."

	((self hasAddress: anAddress) and: [ self hasAddress: anAddress + aCount - 1 ])
		ifFalse: [ ^ nil ].
	^ bytes
		  copyFrom: anAddress - baseAddress + 1
		  to: anAddress - baseAddress + aCount
