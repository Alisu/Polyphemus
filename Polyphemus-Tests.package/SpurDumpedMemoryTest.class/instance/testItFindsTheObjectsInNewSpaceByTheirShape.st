tests
testItFindsTheObjectsInNewSpaceByTheirShape

	"New space has no landmark and a dump no allocation mark, so its objects are found by
	walking, past every survivor the VM kept. It stops on free space, or on stale bytes where
	the VM does not clear what it scavenged (Windows)."

	| walk |
	self assert: dumped raw youngSpaceStart isNotNil.
	self assert: dumped raw youngSpaceStart < dumped raw heapStart.

	walk := dumped raw youngObjectsWalk.
	self assert: walk objectCount > 100.
	self assert: walk stoppedAt < dumped raw heapStart.
	self assert: walk stoppedAt >= (dumped raw vmVariables at: 'pastSpaceStart').
	self assert: (#( #nothingButFreeSpace #classIndexTooLarge #unusedFormat ) includes: walk reason)
