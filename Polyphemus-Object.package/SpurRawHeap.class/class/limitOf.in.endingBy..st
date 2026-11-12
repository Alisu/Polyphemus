instance creation
limitOf: aSegment in: aDump endingBy: anEnd

	"Where old space's mappings end, from aSegment on, touching or across a bridge, up to where the
	VM says its memory ends (anEnd, nil when it does not say): what touches past it is not (#146)."

	^ (self stretchesFrom: aSegment in: aDump endingBy: anEnd) last value
