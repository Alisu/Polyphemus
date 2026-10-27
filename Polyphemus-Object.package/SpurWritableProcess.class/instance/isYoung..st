objects
isYoung: anOop

	"Whether that object is in new space, which a scavenge moves."

	^ anOop >= (self variables at: 'newSpaceStart') and: [ anOop < self variables newSpaceEnd ]
