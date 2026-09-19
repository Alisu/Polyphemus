reading
bytesAt: anAddress count: aCount

	"The offsets of this file are addresses, so there is nothing to translate. Nil when the
	address is not mapped, or when the kernel refuses the read -- a region can go away
	between reading the map and reading the memory, which is what reading something that is
	still running means."

	| read |
	(self hasAddress: anAddress) ifFalse: [ ^ nil ].
	read := [
	        self stream position: anAddress.
	        self stream next: aCount ] on: Error do: [ :e | nil ].
	"All of them or none, as a dump answers: a short read that looks whole is the dangerous
	kind (#15)."
	^ (read notNil and: [ read size = aCount ]) ifTrue: [ read ] ifFalse: [ nil ]
