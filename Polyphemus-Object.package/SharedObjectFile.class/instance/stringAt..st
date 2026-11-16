reading
stringAt: anOffset

	| end |
	end := anOffset + 1.
	[ end <= self bytes size and: [ (self bytes at: end) ~= 0 ] ] whileTrue: [ end := end + 1 ].
	^ (self bytes copyFrom: anOffset + 1 to: end - 1) asString
