editing
whileStillWhereRead: aReifiedObject do: aBlock

	"Stopped outside a collection, aBlock given a way to write into the image -- provided the object
	is where the last reading shows it: of that reading, and no garbage collected since."

	aReifiedObject memory == reading ifFalse: [
		^ StaleReading signal: 'read before the last step: it may have moved since' ].
	askedSince == true ifTrue: [
		^ StaleReading signal: 'the image ran a request since this was read: read it again (a step, or open it again), then edit' ].
	^ reader whileStoppedNotCollecting: [
		  self collectionsSoFar = collections ifFalse: [
			  ^ StaleReading signal: 'the image collected garbage since this was read, and may have moved it' ].
		  aBlock value: (SpurWritableProcess on: reader) ]
