reading
readInto: aBuffer at: anIndex address: anAddress count: aCount

	"As bytesAt:count:, mach_vm_read_overwrite straight into aBuffer, pinned for it: no block of
	its own, no second copy (#135)."

	| read |
	(self hasAddress: anAddress) ifFalse: [ ^ false ].
	read := self class pinned: 8.
	(self class
		 read: task
		 at: anAddress
		 count: aCount
		 into: (ExternalAddress fromAddress: aBuffer tfPointerAddress asInteger + anIndex - 1)
		 size: read) = 0 ifFalse: [ ^ false ].
	^ (read unsignedLongLongAt: 1) = aCount
