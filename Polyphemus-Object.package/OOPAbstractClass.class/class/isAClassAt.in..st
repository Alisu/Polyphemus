instance creation
isAClassAt: anAddress in: aMemory

	"Fixed pointer slots and a place in the class table: what a class, a metaclass and a trait all are."

	^ (aMemory formatOf: anAddress) = 1 and: [ aMemory isInClassTable: anAddress ]
