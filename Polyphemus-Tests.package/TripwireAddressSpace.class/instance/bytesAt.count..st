reading
bytesAt: anAddress count: aCount

	^ TestFailure signal: 'read at ' , anAddress printStringHex , ', past what was needed'
