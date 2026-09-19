reading
bytesAt: anAddress count: aCount

	"The offsets of /proc/<pid>/mem are addresses. All the bytes or nil: a region can go away
	between reading the map and reading the memory (#15)."

	| read |
	(self hasAddress: anAddress) ifFalse: [ ^ nil ].
	read := [
	        self stream position: anAddress.
	        self stream next: aCount ] on: Error do: [ :e | nil ].
	"All of them or none, as a dump answers: a short read that looks whole is the dangerous
	kind (#15)."
	^ (read notNil and: [ read size = aCount ]) ifTrue: [ read ] ifFalse: [ nil ]
