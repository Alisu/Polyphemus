comparing
= anObject

	^ self class = anObject class and: [
		  pharo = anObject pharo and: [ os = anObject os and: [ cpu = anObject cpu ] ] ]
