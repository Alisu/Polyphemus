writing
write: aByteArray at: anAddress

	"Where /proc/<pid>/mem says: its offsets are addresses."

	self writeStream position: anAddress.
	self writeStream nextPutAll: aByteArray.
	self writeStream flush
