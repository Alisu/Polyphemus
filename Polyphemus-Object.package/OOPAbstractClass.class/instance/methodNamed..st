finding
methodNamed: aString

	^ self
		  methodNamed: aString
		  ifAbsent: [ NotInTheReading signal: 'no method named ' , aString , ' in this class' ]
