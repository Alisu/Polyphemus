reading
bytesAt: anAddress count: aCount

	"The offsets of /proc/<pid>/mem are addresses, and a read answers all the bytes or nil
	(#15). Sought away from first: a second read of one position answers the first read's
	bytes, and a live process changes under us (#26)."

	| read |
	(self hasAddress: anAddress) ifFalse: [ ^ nil ].
	read := [
	        self stream position: 0.
	        self stream position: anAddress.
	        self stream next: aCount ] on: Error do: [ :e | nil ].
	"All of them or none, as a dump answers: a short read that looks whole is the dangerous
	kind (#15)."
	^ (read notNil and: [ read size = aCount ]) ifTrue: [ read ] ifFalse: [ nil ]
