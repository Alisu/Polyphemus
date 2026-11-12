instance creation
stretchesFrom: aSegment in: aDump endingBy: anEnd

	"Old space's mappings from aSegment on, start -> limit, each touching the last or across its
	bridge, up to where the VM says its memory ends (anEnd, nil when it does not say): what touches
	past it is not old space (#146), nor is what lies between two of them (#185)."

	| stretches limit bridged following |
	stretches := OrderedCollection with: aSegment address -> (aSegment address + aSegment sizeInFile).
	[
	limit := stretches last value.
	(anEnd isNil or: [ limit < anEnd ]) and: [
		bridged := self segmentAfterBridgeEndingAt: limit in: aDump.
		following := aDump loadableSegments
			             detect: [ :each | (each address = limit or: [ each address = bridged ]) and: [ each sizeInFile > 0 ] ]
			             ifNone: [ nil ].
		following notNil ] ] whileTrue: [
		stretches add: following address -> (following address + following sizeInFile) ].
	^ stretches
