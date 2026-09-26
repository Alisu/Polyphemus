editing
whileStillWhereRead: aReifiedObject do: aBlock

	"Stopped, aBlock given a way to write into the image -- provided the object is where the
	last reading shows it: of that reading, and the image has not collected garbage since."

	aReifiedObject memory == reading ifFalse: [
		^ self error: 'read before the last step: it may have moved since' ].
	^ reader whileStopped: [
		  self collectionsSoFar = collections ifFalse: [
			  ^ self error: 'the image collected garbage since this was read, and may have moved it' ].
		  aBlock value: (SpurWritableProcess on: reader) ]
