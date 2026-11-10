objects
allocateSlots: aCount format: aFormat classIndex: anIndex

	"In eden, below scavengeThreshold as the VM allocates (macOS's VM names no eden): at freeStart,
	moved past it. From 255 slots the header says 255, the real count in an overflow word before it."

	| start address bytes |
	start := self variables at: 'freeStart'.
	address := aCount >= 255 ifTrue: [ start + 8 ] ifFalse: [ start ].
	bytes := address - start + 8 + ((aCount max: 1) * 8).
	start + bytes > (self variables at: 'scavengeThreshold') ifTrue: [
		^ NotInTheReading signal: 'that image has no room left in its eden' ].
	address > start ifTrue: [ self wordAt: start put: (SpurHeader overflowWordFor: aCount) ].
	self wordAt: address put: (SpurHeader headerFor: aCount format: aFormat classIndex: anIndex).
	1 to: (aCount max: 1) do: [ :each | self wordAt: address + (each * 8) put: 0 ].
	self wordAt: (self variables addressOf: 'freeStart') put: start + bytes.
	^ address
