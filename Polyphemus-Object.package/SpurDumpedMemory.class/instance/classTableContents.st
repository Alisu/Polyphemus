reading
classTableContents

	"Every page of the class table as this copy holds it, its bytes: which class is at each index.
	The table's root lists its pages until nil."

	| scanner root pages |
	scanner := raw scanner.
	root := scanner hiddenRootsFrom: raw heapStart.
	pages := OrderedCollection new.
	1 to: 4096 do: [ :each |
		| page |
		page := scanner slotOf: root at: each.
		page = raw heapStart ifTrue: [ ^ pages asArray ].
		pages add: (raw space bytesAt: page + 8 count: 1024 * 8) ].
	^ pages asArray
