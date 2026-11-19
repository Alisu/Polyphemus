reading
signedIn: someBytes from: anIndex size: aCount

	"As unsignedIn:from:size:, the highest bit taken as the sign: a C int of the VM's."

	| value |
	value := self unsignedIn: someBytes from: anIndex size: aCount.
	^ value >= (1 bitShift: aCount * 8 - 1)
		  ifTrue: [ value - (1 bitShift: aCount * 8) ]
		  ifFalse: [ value ]
