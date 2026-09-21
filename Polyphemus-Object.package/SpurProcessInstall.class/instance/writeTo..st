writing
writeTo: aPath

	"Nothing to write: a running image is where it already is."

	^ self error: 'a running image is not written out; it is where it is'
