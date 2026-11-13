finding
methodNamed: aString

	^ self methodNamed: aString ifAbsent: [ NotFound signalFor: aString ]
