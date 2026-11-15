accessing
oopPropertyAt: aKey ifAbsent: aBlock

	"From its properties as the image keeps them: an AdditionalMethodState, of key -> value
	pairs. Refused by name where they do not read."

	| properties |
	properties := self penultimateLiteral.
	((properties isKindOf: OOPAbstractObject) and: [ properties oopClassName = 'AdditionalMethodState' ])
		ifFalse: [ ^ aBlock value ].
	properties allReifiedSlots do: [ :each |
		| key |
		key := (each isKindOf: OOPAbstractObject) ifTrue: [ each oopSlotNamed: 'key' ].
		((key isKindOf: OOPString) and: [ key asString = aKey asString ]) ifTrue: [ ^ each oopSlotNamed: 'value' ] ].
	^ aBlock value
