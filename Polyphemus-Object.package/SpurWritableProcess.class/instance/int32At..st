words
int32At: anAddress

	"A C int of the VM's, signed: the tides start at a negative mark."

	| value |
	value := (self bytesAt: anAddress count: 4) reverse inject: 0 into: [ :sum :byte |
		         sum * 256 + byte ].
	^ value >= 16r80000000
		  ifTrue: [ value - 16r100000000 ]
		  ifFalse: [ value ]
