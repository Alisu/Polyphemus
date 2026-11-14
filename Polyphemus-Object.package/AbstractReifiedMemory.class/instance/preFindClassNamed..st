finding
preFindClassNamed: aString

	^ self
		  preFindClassNamed: aString
		  ifAbsent: [ NotInTheReading signal: 'no class named ' , aString , ' in this image' ]
