young objects
youngObjectsWalk

	"What walking new space finds. Nil when nothing there walks.

	It stops where the live objects stop, which is the allocation mark the dump does not
	carry -- so the walk is not merely a way of reading eden, it is the only way of knowing
	how much of eden there is to read."

	^ self youngSpaceStart ifNotNil: [ :start |
		  self scanner walkFrom: start upTo: self heapStart ]
