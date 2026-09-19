reading
stringAt: anIndex

	| end |
	end := anIndex.
	[ (self bytes at: end) = 0 ] whileFalse: [ end := end + 1 ].
	^ (self bytes copyFrom: anIndex to: end - 1) asString
