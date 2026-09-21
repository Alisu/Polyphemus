editing
storeBytes: aByteArray at: anAddress

	"Into the process itself, which refuses unless it is stopped."

	^ process storeBytes: aByteArray at: anAddress
