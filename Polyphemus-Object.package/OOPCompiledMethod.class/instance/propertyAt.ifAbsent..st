debugger protocol
propertyAt: aKey ifAbsent: aBlock

	"From its properties as the image keeps them: an AdditionalMethodState, of key -> value pairs."

	| properties |
	(properties := self penultimateLiteral) isMethodProperties ifTrue: [
		^ properties propertyAt: aKey ifAbsent: aBlock ].
	((properties isKindOf: OOPAbstractObject) and: [ properties oopClassName = 'AdditionalMethodState' ])
		ifFalse: [ ^ aBlock value ].
	properties allReifiedSlots do: [ :each |
		| key |
		key := (each isKindOf: OOPAbstractObject) ifTrue: [ [ each oopSlotNamed: 'key' ] on: Error do: [ :e | nil ] ].
		((key isKindOf: OOPString) and: [ key asString = aKey asString ]) ifTrue: [ ^ each oopSlotNamed: 'value' ] ].
	^ aBlock value
