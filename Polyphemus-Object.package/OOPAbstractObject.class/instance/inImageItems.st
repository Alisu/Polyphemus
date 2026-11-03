inspection
inImageItems

	"As Pharo's inspector lists the kinds it knows (#95); any other object by its variables."

	| chain |
	chain := self oopClassChainNames.
	(chain includes: 'MethodDictionary') ifTrue: [ ^ self inImageItemsOfAMethodDictionary ].
	(chain includes: 'Dictionary') ifTrue: [ ^ self inImageItemsOfADictionary ].
	(chain includes: 'Bag') ifTrue: [ ^ (self oopSlotNamed: 'contents') inImageItems ].
	(chain includes: 'Set') ifTrue: [ ^ self inImageItemsOfASet ].
	(chain includes: 'OrderedCollection') ifTrue: [ ^ self inImageItemsOfAnOrderedCollection ].
	^ self inImageItemsByName
