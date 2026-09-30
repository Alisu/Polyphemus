tests
testOtherwiseTheMostBytesWinWhicheverComesFirst

	"24 bytes against 8 in pixel 0, in both orders."

	self
		assert: ((self painterFor: #( #( 40 1 2 ) #( 41 16 1 ) ) bytesPerPixel: 32) categoryOfPixel: 0)
		equals: #pointers.
	self
		assert: ((self painterFor: #( #( 41 16 2 ) #( 40 1 1 ) ) bytesPerPixel: 32) categoryOfPixel: 0)
		equals: #bytes
