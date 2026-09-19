reading
bytes

	"The whole file, checked to be a 64-bit little endian ELF file. A VM library is a few
	megabytes; it is read once."

	^ bytes ifNil: [
		  bytes := file binaryReadStreamDo: [ :stream | stream upToEnd ].
		  ((bytes first: 4) asArray = #( 16r7F 69 76 70 ) and: [
			   (bytes at: 5) = 2 and: [ (bytes at: 6) = 1 ] ]) ifFalse: [
			  bytes := nil.
			  ^ self error: file basename , ' is not a 64 bit little endian ELF file' ].
		  bytes ]
