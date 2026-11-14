finding
atOrBefore: anAddress

	"The object kept at anAddress, or the last one below it."

	| best |
	(self holds: anAddress) ifFalse: [ ^ NotInTheReading signal: 'no object at or before ' , anAddress printStringHex ].
	objects keysDo: [ :each |
		(each <= anAddress and: [ best isNil or: [ each > best ] ]) ifTrue: [ best := each ] ].
	^ best ifNil: [ NotInTheReading signal: 'no object at or before ' , anAddress printStringHex ] ifNotNil: [ objects at: best ]
