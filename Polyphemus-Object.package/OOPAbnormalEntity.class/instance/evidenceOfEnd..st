guessing
evidenceOfEnd: anEnd

	^ anEnd = (address + size)
		  ifTrue: [ 'it fills its gap of {1} bytes' format: { size } ]
		  ifFalse: [ 'it ends at {1}, where sound objects begin that run to the end of its gap' format: { anEnd printStringHex } ]
