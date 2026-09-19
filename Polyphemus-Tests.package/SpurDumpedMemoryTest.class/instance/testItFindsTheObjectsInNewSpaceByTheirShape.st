tests
testItFindsTheObjectsInNewSpaceByTheirShape

	"New space has no landmark and a dump no allocation mark, so its objects are found by
	walking. The walk stopping on free space is not a failure: it is the allocation mark."

	| walk |
	self assert: dumped raw youngSpaceStart isNotNil.
	self assert: dumped raw youngSpaceStart < dumped raw heapStart.

	walk := dumped raw youngObjectsWalk.
	self assert: walk objectCount > 100.
	self assert: walk stoppedAt < dumped raw heapStart.
	self assert: walk reason equals: #nothingButFreeSpace
