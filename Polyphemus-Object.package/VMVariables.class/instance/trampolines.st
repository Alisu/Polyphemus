accessing
trampolines

	"Address -> name of the routines Cog generated below its methods, trampolines and
	enilopmarts: the library's ce... variables whose value lies from codeBase up to
	methodZoneBase."

	^ trampolines ifNil: [
		  | low high |
		  low := self at: 'codeBase'.
		  high := self at: 'methodZoneBase'.
		  trampolines := Dictionary new.
		  (self library variableNames select: [ :each | each beginsWith: 'ce' ]) asSortedCollection
			  do: [ :each |
				  (memory unsignedAt: (self addressOf: each) size: 8) ifNotNil: [ :value |
					  (value between: low and: high - 1) ifTrue: [
						  trampolines at: value ifAbsentPut: [ each ] ] ] ].
		  trampolines ]
