initialization
readFrom: aFileReference

	"The header, then the segments. Nothing is refused here: what cannot be read is left out,
	and the readability ladder says so."

	file := aFileReference asFileReference.
	stream := nil.
	segments := OrderedCollection new.
	header := self bytesAtOffset: 0 count: 88.
	self isSpur64 ifTrue: [ self readSegments ]
