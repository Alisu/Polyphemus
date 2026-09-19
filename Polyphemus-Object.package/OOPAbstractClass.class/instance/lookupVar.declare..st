variables
lookupVar: aName declare: aBoolean

	"Resolve aName as the image being read would: instance variables, class variables, then
	globals. Answers a variable of this image describing that one, with its index over
	there."

	| layout index classVariable |
	layout := self reifiedSlotAt: 4.
	(self acceptableLayout includes: layout oopClassName) ifFalse: [
		index := self allInstVarNames indexOf: aName asString.
		index isZero ifFalse: [
			^ (InstanceVariableSlot named: aName asString asSymbol)
				  index: index;
				  yourself ] ].

	classVariable := self classVariableNamed: aName.
	classVariable ifNotNil: [ ^ classVariable ].

	^ self lookupReservedOrGlobal: aName
