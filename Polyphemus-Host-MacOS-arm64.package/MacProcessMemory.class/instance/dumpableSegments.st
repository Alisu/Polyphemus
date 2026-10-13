reading the map
dumpableSegments

	"The readable regions that are the process's own: not those inside a submap, where macOS maps
	the shared libraries cache (gigabytes, the same in every process)."

	| found |
	found := OrderedCollection new.
	self regionsDo: [ :from :bytes :protection :offset :depth |
		(depth = 0 and: [ (protection bitAnd: 1) = 1 ]) ifTrue: [
			found add: (ElfCoreSegment new
					 kind: 1
					 address: from
					 offset: from
					 inFile: bytes
					 inMemory: bytes;
					 yourself) ] ].
	^ found asArray
