pathFinding
pathToMinimalPharo: aNumber

	^ self
		  pathToImage: (self nameForMinimalPharo: aNumber) , '.image'
		  fetchingWith: [ self getMinimalImageForPharo: aNumber ]
