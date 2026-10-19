reading
unsignedAt: anAddress size: aCount

	^ TestFailure signal: 'read at ' , anAddress printStringHex , ', past what was needed'
