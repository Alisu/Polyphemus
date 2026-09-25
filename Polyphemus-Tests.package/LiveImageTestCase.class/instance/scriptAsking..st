helpers
scriptAsking: aSelector

	"What the held image is asked to run: forget the lookups it has cached, collect its
	garbage -- which is where a pointer we failed to remember would be lost -- and answer."

	^ 'Integer flushCache. Smalltalk garbageCollect. '''
	  , (self spikeDirectory / 'live-answer') fullName
	  , ''' asFileReference writeStreamDo: [ :stream | stream nextPutAll: (3 ' , aSelector
	  , ') printString ]'
