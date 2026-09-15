private
cacheHolds: anOffset count: aCount

	^ cacheBytes notNil and: [
		  anOffset >= cacheStart and: [
			  anOffset + aCount - 1 < (cacheStart + cacheBytes size) ] ]
