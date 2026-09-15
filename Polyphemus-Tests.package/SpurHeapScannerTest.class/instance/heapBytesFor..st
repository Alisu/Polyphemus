building a heap
heapBytesFor: aCollectionOfSpecs

	"Each spec is class index, format and slot count. An object asking for 255 slots or more
	gets an overflow word in front of it, whose own slot count byte is saturated -- which is
	what a walk looks for to tell the two apart.

	The header states the slot count it was given, including zero, while the object still
	takes one slot of room: nil says nought slots and occupies sixteen bytes, because a
	forwarding pointer has to fit somewhere."

	^ ByteArray streamContents: [ :stream |
		  aCollectionOfSpecs do: [ :spec |
			  | classIndex format slots stored |
			  classIndex := spec at: 1.
			  format := spec at: 2.
			  slots := spec at: 3.
			  stored := slots max: 1.
			  slots >= 255
				  ifTrue: [
					  self putWord: (255 bitShift: 56) + slots on: stream.
					  self
						  putWord: (self headerForClass: classIndex format: format slots: 255)
						  on: stream ]
				  ifFalse: [
					  self
						  putWord: (self headerForClass: classIndex format: format slots: slots)
						  on: stream ].
			  stored * 8 timesRepeat: [ stream nextPut: 16r55 ] ] ]
