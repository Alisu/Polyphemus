objects
allocateSlots: aCount format: aFormat classIndex: anIndex filledWith: aWord

	"At the end of past space: in eden the VM's allocation holds freeStart through a stop and
	writes over what was made (#137, #167). Each slot aWord, pastSpaceStart moved past it once
	whole (#163); from 255 slots the real count goes in an overflow word before the header."

	| start address bytes |
	start := self variables at: 'pastSpaceStart'.
	address := aCount >= 255 ifTrue: [ start + 8 ] ifFalse: [ start ].
	bytes := address - start + 8 + ((aCount max: 1) * 8).
	start + bytes > (self variables boundsOf: 'pastSpace') value ifTrue: [
		^ NotInTheReading signal: 'that image has no room left in its past space' ].
	address > start ifTrue: [ self wordAt: start put: (SpurHeader overflowWordFor: aCount) ].
	self wordAt: address put: (SpurHeader headerFor: aCount format: aFormat classIndex: anIndex).
	1 to: (aCount max: 1) do: [ :each | self wordAt: address + (each * 8) put: aWord ].
	self wordAt: (self variables addressOf: 'pastSpaceStart') put: start + bytes.
	^ address
