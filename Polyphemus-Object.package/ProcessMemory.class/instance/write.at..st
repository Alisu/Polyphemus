writing
write: aByteArray at: anAddress

	"Write them there, as this host can; the process is stopped and has that address."

	^ self subclassResponsibility
