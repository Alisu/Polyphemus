objects
allocateSlots: aCount format: aFormat classIndex: anIndex filledWith: aWord

	"A reading is not running: filled once made."

	| oop |
	oop := self allocateSlots: aCount format: aFormat classIndex: anIndex.
	0 to: aCount - 1 do: [ :each | self wordAt: oop + 8 + (each * 8) put: aWord ].
	^ oop
