words
int32At: anAddress

	"A C int of the VM's, signed: the tides start at a negative mark."

	^ LittleEndian signedIn: (self bytesAt: anAddress count: 4) from: 1 size: 4
