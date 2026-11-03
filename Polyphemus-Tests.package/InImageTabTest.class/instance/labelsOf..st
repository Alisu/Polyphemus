accessing
labelsOf: anEntity

	^ anEntity inImageItems collect: [ :each | each key ]
