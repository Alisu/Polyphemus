walking
isFreeChunkAt: anAddress

	"Spur marks free space with a class index of zero -- isFreeObjectClassIndexPun. What is
	inside is the free list's own links, not references to objects."

	| header |
	header := self headerAt: anAddress.
	^ header notNil and: [ (self classIndexIn: header) = 0 ]
