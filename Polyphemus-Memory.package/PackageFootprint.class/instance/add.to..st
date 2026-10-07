taking
add: anOop to: aPackageName

	(owned includes: anOop) ifTrue: [ ^ self ].
	owned add: anOop.
	counts at: aPackageName put: (counts at: aPackageName ifAbsent: [ 0 ]) + 1.
	sizes at: aPackageName put: (sizes at: aPackageName ifAbsent: [ 0 ]) + (census bytesOfObjectAt: anOop)
