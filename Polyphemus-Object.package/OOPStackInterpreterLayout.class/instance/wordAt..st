reading
wordAt: anAddress

	"The word of the simulator's stack pages there. An address off them is refused by name:
	VMMaker fails on one in its own ways."

	self refuseUnlessOnTheStackPages: anAddress.
	^ memory interpreter stackPages unsignedLongAt: anAddress
