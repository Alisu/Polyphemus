allocating
allocateSlots: aCount format: aFormat classIndex: anIndex hash: aHash

	"An object in the image's eden, where the machine allocates as well: written where
	freeStart says, and freeStart moved past it. Old space ends at its bridge in a running
	image, so there is nowhere else to put one."

	| address bytes header |
	address := variables at: 'freeStart'.
	bytes := 8 + ((aCount max: 1) * 8).
	address + bytes > (variables boundsOf: 'eden') value ifTrue: [
		^ self error: 'that image has no room left in its eden' ].
	header := (aCount bitShift: 56) + (aHash bitShift: 32) + (aFormat bitShift: 24)
	          + anIndex.
	process storeWord: header at: address.
	1 to: (aCount max: 1) do: [ :each | process storeWord: 0 at: address + (each * 8) ].
	process storeWord: address + bytes at: (variables addressOf: 'freeStart').
	^ address
