accessing
lines

	"One line per package, the heaviest first."

	^ (counts keys collect: [ :each | HeapCensusLine name: each count: (counts at: each) bytes: (sizes at: each) ])
		  asSortedCollection: [ :a :b | a bytes >= b bytes ]
