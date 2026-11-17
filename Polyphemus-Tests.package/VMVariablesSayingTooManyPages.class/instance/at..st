reading
at: aName

	^ aName = 'numStackPages' ifTrue: [ 70000 ] ifFalse: [ 16r1000 ]
