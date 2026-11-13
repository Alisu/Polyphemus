finding
methodNamed: aString ifAbsent: aBlock

	^ self reifiedMethods detect: [ :m | m oopSelector asString = aString ] ifNone: aBlock
