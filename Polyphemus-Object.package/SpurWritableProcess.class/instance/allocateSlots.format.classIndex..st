objects
allocateSlots: aCount format: aFormat classIndex: anIndex

	"In eden, where the machine allocates too: at freeStart, which is moved past it. Old space
	in a running image ends at its bridge, so there is nowhere else."

	| address bytes |
	address := self variables at: 'freeStart'.
	bytes := 8 + ((aCount max: 1) * 8).
	address + bytes > (self variables boundsOf: 'eden') value ifTrue: [
		^ self error: 'that image has no room left in its eden' ].
	self
		wordAt: address
		put: (aCount bitShift: 56) + (aFormat bitShift: 24) + anIndex.
	1 to: (aCount max: 1) do: [ :each | self wordAt: address + (each * 8) put: 0 ].
	self wordAt: (self variables addressOf: 'freeStart') put: address + bytes.
	^ address
