building
indexOfSlotNamed: aName in: anObject

	| index |
	index := (anObject oopClass allOopSlotNames collect: [ :each | each asString ]) asArray indexOf: aName.
	index = 0 ifTrue: [ self error: 'no slot named ' , aName ].
	^ index
