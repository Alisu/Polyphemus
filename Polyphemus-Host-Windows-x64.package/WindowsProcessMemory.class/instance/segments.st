reading the map
segments

	"Every committed region it may read (no guard page, some read right), read once."

	| found |
	segments ifNotNil: [ ^ segments ].
	found := OrderedCollection new.
	self regionsDo: [ :from :bytes :state :protection |
		(state = 16r1000 and: [ (protection bitAnd: 16r100) = 0 and: [ (protection bitAnd: 16rEE) ~= 0 ] ]) ifTrue: [
			found add: (ElfCoreSegment new
					 kind: 1
					 address: from
					 offset: from
					 inFile: bytes
					 inMemory: bytes;
					 yourself) ] ].
	^ segments := found asArray
