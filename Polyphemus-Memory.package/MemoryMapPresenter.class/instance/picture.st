accessing
picture

	"New space above old space, at old space's scale (a million pixels at most for it). In new
	space only the survivors and eden up to its allocation pointer hold objects."

	^ picture ifNil: [
		  | old new scavenger |
		  old := MemoryMapPainter
			         on: self scanner
			         geometry: (MemoryMapGeometry
					          from: objectMemory nilObject
					          to: objectMemory freeOldSpaceStart
					          fittingPixels: 1000000
					          width: 1024).
		  old paintFrom: old geometry start upTo: old geometry end.
		  new := MemoryMapPainter
			         on: self scanner
			         geometry: (MemoryMapGeometry
					          from: objectMemory newSpaceStart
					          to: objectMemory newSpaceLimit
					          bytesPerPixel: old geometry bytesPerPixel
					          width: 1024).
		  scavenger := objectMemory scavenger.
		  new paintFrom: scavenger pastSpace start upTo: objectMemory pastSpaceStart.
		  new paintFrom: scavenger eden start upTo: objectMemory freeStart.
		  picture := MemoryMapPicture onSections: {
				             ('new space' -> new).
				             ('old space' -> old) } ]
