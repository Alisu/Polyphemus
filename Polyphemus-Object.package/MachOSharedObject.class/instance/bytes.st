accessing
bytes

	^ bytes ifNil: [ bytes := file asFileReference binaryReadStreamDo: [ :s | s upToEnd ] ]
