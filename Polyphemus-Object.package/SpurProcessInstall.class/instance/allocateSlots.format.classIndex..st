memory
allocateSlots: aCount format: aFormat classIndex: anIndex

	"In the image's eden, where the machine allocates as well: written where freeStart says,
	and freeStart moved past it. Old space ends at its bridge in a running image, so there is
	nowhere else to put one."

	| address bytes |
	address := variables at: 'freeStart'.
	bytes := 8 + ((aCount max: 1) * 8).
	address + bytes > (variables boundsOf: 'eden') value ifTrue: [
		^ self error: 'that image has no room left in its eden' ].
	self
		wordAt: address
		put: (aCount bitShift: 56) + (aFormat bitShift: 24) + anIndex.
	1 to: (aCount max: 1) do: [ :each | self wordAt: address + (each * 8) put: 0 ].
	self wordAt: (variables addressOf: 'freeStart') put: address + bytes.
	^ address
