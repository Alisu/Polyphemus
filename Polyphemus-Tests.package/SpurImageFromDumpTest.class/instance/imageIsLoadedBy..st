helpers
imageIsLoadedBy: aProcessReader

	"Whether that machine has the image in memory: readable is not ready, the permission
	being there before the heap is. A reader of its own each time -- one reads the map once."

	^ aProcessReader exists and: [
		  (aProcessReader loadableSegments inject: 0 into: [ :most :each |
			   most max: each sizeInFile ]) > 40000000 ]
