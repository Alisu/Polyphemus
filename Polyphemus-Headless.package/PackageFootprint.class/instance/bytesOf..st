accessing
bytesOf: aPackageName

	^ sizes at: aPackageName ifAbsent: [ 0 ]
