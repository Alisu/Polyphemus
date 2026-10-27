reading the map
writableSegments

	"The committed regions it may write (read-write, write-copy, and their executable kinds):
	what can change while it runs (#85)."

	| found |
	found := OrderedCollection new.
	self regionsDo: [ :from :bytes :state :protection |
		(state = 16r1000 and: [ (protection bitAnd: 16r100) = 0 and: [ (protection bitAnd: 16rCC) ~= 0 ] ]) ifTrue: [
			found add: (ElfCoreSegment ofProcessAt: from size: bytes) ] ].
	^ found asArray
