reading the map
writableSegments

	"The process's own regions it may read and write: what can change while it runs (#85)."

	| found |
	found := OrderedCollection new.
	self regionsDo: [ :from :bytes :protection :offset :depth |
		(depth = 0 and: [ (protection bitAnd: 3) = 3 ]) ifTrue: [
			found add: (ElfCoreSegment new
					 kind: 1
					 address: from
					 offset: from
					 inFile: bytes
					 inMemory: bytes;
					 yourself) ] ].
	^ found asArray
