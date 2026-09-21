memory
wordAt: anAddress

	"The word this memory holds there."

	^ memory unsignedLong64At: anAddress
