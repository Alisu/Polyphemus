tests
testUsedShowsOverFree

	"Pixel 0 holds 24 free bytes and 8 used ones: free only where all of a pixel is."

	| painter |
	painter := self painterFor: #( #( 0 1 2 ) #( 40 1 1 ) ) bytesPerPixel: 32.

	self assert: (painter categoryOfPixel: 0) equals: #pointers
