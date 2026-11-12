holding it still
whileStoppedToRemember: aBlock

	"aBlock's value, stopped at a moment to make objects or remember one (whyNotToAllocateIn:):
	looked for as whileStoppedNotCollecting: looks, and refused the same way (#167)."

	^ self whileStoppedUnless: [ :variables | self class whyNotToAllocateIn: variables ] do: aBlock
