memory protocol
long32At: anAddress

	| value |
	value := space unsignedAt: anAddress size: 4.
	^ value >= 16r80000000 ifTrue: [ value - 16r100000000 ] ifFalse: [ value ]
