editing
whileStillWhereRead: aReifiedObject do: aBlock

	"Stopped outside a collection and machine code, aBlock given a way to write into the image -- if
	the object is where the last reading shows it: of that reading, no garbage collected since."

	aReifiedObject memory == reading ifFalse: [
		^ StaleReading signal: 'read before the last step: it may have moved since' ].
	^ reader whileStoppedToAllocate: [
		  self collectionsSoFar = collections ifFalse: [
			  ^ StaleReading signal: 'the image collected garbage since this was read, and may have moved it' ].
		  aBlock value: (SpurWritableProcess on: reader) ]
