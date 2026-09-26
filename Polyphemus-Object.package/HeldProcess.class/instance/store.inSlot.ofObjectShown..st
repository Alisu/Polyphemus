editing
store: aValue inSlot: anIndex ofObjectShown: aReifiedObject

	"Set, stopped, a slot of an object the last reading shows. Refused when the object may have
	moved since: read before the last step, or the image collected garbage since the reading."

	aReifiedObject memory == reading ifFalse: [
		^ self error: 'read before the last step: it may have moved since' ].
	reader whileStopped: [
		self collectionsSoFar = collections ifFalse: [
			^ self error: 'the image collected garbage since this was read, and may have moved it' ].
		(SpurEdit on: (SpurWritableProcess on: reader) reading: reading)
			store: aValue
			inSlot: anIndex
			ofObjectShown: aReifiedObject ]
