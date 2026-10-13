reading the map
segments

	"Every readable region, read once."

	| found |
	segments ifNotNil: [ ^ segments ].
	found := OrderedCollection new.
	self regionsDo: [ :from :bytes :protection :offset :depth |
		(protection bitAnd: 1) = 1 ifTrue: [
			found add: (ElfCoreSegment new
					 kind: 1
					 address: from
					 offset: from
					 inFile: bytes
					 inMemory: bytes;
					 yourself) ] ].
	^ segments := found asArray
