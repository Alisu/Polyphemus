editing
bytesAt: anAddress count: aCount

	"What the process holds there, read afresh (#26)."

	^ (process bytesAt: anAddress count: aCount)
		  ifNil: [ self error: 'nothing is mapped at ' , anAddress printStringHex ]
		  ifNotNil: [ :bytes | bytes asArray ]
