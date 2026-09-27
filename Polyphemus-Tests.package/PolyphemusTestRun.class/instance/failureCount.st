accessing
failureCount

	^ (self problems select: [ :each | self isFailure: each value ]) size
