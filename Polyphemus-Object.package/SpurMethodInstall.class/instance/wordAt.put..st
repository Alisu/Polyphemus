memory
wordAt: anAddress put: aWord

	"Write one word where this memory has that address."

	^ memory unsignedLong64At: anAddress put: aWord
