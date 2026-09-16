reading
stream

	^ stream ifNil: [
		  stream := (self pathFor: 'mem') asFileReference binaryReadStream ]
