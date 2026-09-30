running
setUp

	"Pointers, then bytes: two pixels each, eight bytes a pixel."

	super setUp.
	picture := MemoryMapPicture on: (self painterFor: #( #( 40 1 1 ) #( 41 16 1 ) ) bytesPerPixel: 8)
