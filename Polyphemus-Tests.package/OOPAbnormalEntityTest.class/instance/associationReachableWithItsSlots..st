building
associationReachableWithItsSlots: aBoolean
	"An association between sound objects, read from an object made before it, as its key and
	value are when aBoolean is true."

	| referencer association key value |
	referencer := self newOldSpaceObjectWithSlots: 3.
	association := self
		newOldSpaceObjectWithSlots: 2
		format: memory nonIndexablePointerFormat
		classIndex: self associationClassIndex.
	key := self newOldSpaceObjectWithSlots: 0.
	value := self newOldSpaceObjectWithSlots: 0.
	self newOldSpaceObjectWithSlots: 1.
	memory storePointer: 0 ofObject: association withValue: key.
	memory storePointer: 1 ofObject: association withValue: value.
	memory storePointer: 0 ofObject: referencer withValue: association.
	aBoolean ifTrue: [
		memory storePointer: 1 ofObject: referencer withValue: key.
		memory storePointer: 2 ofObject: referencer withValue: value ].
	^ association
