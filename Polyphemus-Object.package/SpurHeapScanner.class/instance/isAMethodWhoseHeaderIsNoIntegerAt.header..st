reading headers
isAMethodWhoseHeaderIsNoIntegerAt: anAddress header: aHeader

	"Whether the object here is compiled code whose first slot, its header, is no SmallInteger:
	in an image file damage, in a dump what a jitted method has."

	^ (self formatIn: aHeader) >= 24 and: [ ((self slotOf: anAddress at: 1) bitAnd: 7) ~= 1 ]
