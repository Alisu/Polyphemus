bytes
bytesAt: anAddress count: aCount

	"Read afresh each time (#26)."

	^ (process bytesAt: anAddress count: aCount)
		  ifNil: [ self error: 'nothing is mapped at ' , anAddress printStringHex ]
		  ifNotNil: [ :bytes | bytes asArray ]
