initialization
setUpStringClasses
	" This is mostly guess work."
	|  stringClassAddress stringClasses |
	stringClasses := Set new.
	stringClasses add: memory classString.
	self isSimulator ifTrue: [ ^ self "There most likely is no string classes instanciated" ].
	stringClassAddress := mode stringClassAddressFor: memory.
	
	"A table entry that reads as no class is passed over: one damaged entry is not every string's."
	memory classTableEntriesDo: [ :aClassTableAddress :anIndex | | parent |
		parent := self readableSuperclassOf: aClassTableAddress.
		(parent = stringClassAddress
			or: [ parent notNil and: [ (self readableSuperclassOf: parent) = stringClassAddress ] ])
				ifTrue: [ stringClasses add: aClassTableAddress ] ].

	stringClasses collect: [ :anOop | memory rawHashBitsOf: anOop ] into: stringClassIndexes