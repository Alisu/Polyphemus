reading
byteAt: anAddress

	self refuseUnlessOnTheStackPages: anAddress.
	^ memory interpreter stackPages byteAt: anAddress
