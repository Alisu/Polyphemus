instance creation
limitOf: aSegment in: aDump endingBy: anEnd

	"Where old space's mappings end, from aSegment on, touching or across a bridge, up to where the
	VM says its memory ends (anEnd, nil when it does not say): what touches past it is not (#146)."

	| limit bridged following |
	limit := aSegment address + aSegment sizeInFile.
	[
	(anEnd isNil or: [ limit < anEnd ]) and: [
		bridged := self segmentAfterBridgeEndingAt: limit in: aDump.
		following := aDump loadableSegments
			             detect: [ :each | (each address = limit or: [ each address = bridged ]) and: [ each sizeInFile > 0 ] ]
			             ifNone: [ nil ].
		following notNil ] ] whileTrue: [ limit := following address + following sizeInFile ].
	^ limit
