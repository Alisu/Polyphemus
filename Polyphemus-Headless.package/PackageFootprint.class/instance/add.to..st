taking
add: anOop to: aPackageName

	(owned includes: anOop) ifTrue: [ ^ self ].
	owned add: anOop.
	self count: aPackageName bytes: (census bytesOfObjectAt: anOop)
