building a heap
heapBytesFor: aCollectionOfSpecs

	"Bytes of a hand-built heap. A spec is class index, format, slot count and optional first
	slots; 255 slots or more get an overflow word; zero slots still take one."

	^ ByteArray streamContents: [ :stream |
		  aCollectionOfSpecs do: [ :spec |
			  | classIndex format slots stored contents |
			  classIndex := spec at: 1.
			  format := spec at: 2.
			  slots := spec at: 3.
			  stored := slots max: 1.
			  contents := spec size >= 4
				              ifTrue: [ spec at: 4 ]
				              ifFalse: [ #(  ) ].
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
			  contents do: [ :word | self putWord: word on: stream ].
			  (stored - contents size) * 8 timesRepeat: [ stream nextPut: 16r55 ] ] ]
