watching
checkFileWritten: aFileReference

	"An image file written is read back at once: once the test ends, it may be gone (#141)."

	current ifNil: [ ^ self ].
	current checkFileWritten: aFileReference
