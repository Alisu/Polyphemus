accessing
whyNot: aLevel

	^ self refusals at: aLevel ifAbsent: [ nil ]
