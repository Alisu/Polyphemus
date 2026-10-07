accessing
lines

	"One line per class, the heaviest first."

	^ (counts keys collect: [ :each |
		   HeapCensusLine name: (self nameOfIndex: each) count: (counts at: each) bytes: (sizes at: each) ])
		  asSortedCollection: [ :a :b | a bytes >= b bytes ]
