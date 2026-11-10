holding it still
whileStoppedToAllocate: aBlock

	"aBlock's value, stopped outside a collection and outside machine code: to make objects in
	eden (#163, risks 3 and 4)."

	^ self whileStoppedUnless: [ :variables | self class whyNotToAllocateIn: variables ] do: aBlock
