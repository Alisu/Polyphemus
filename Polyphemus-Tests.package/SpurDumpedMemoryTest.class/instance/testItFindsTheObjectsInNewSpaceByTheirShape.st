tests
testItFindsTheObjectsInNewSpaceByTheirShape

	"Old space is found by its first three objects; new space has no landmark at all, and a
	dump does not carry the allocation mark saying how much of eden is in use. So the objects
	are found the only way left: they walk, and noise does not.

	The walk stopping on nothing but free space is not a failure -- it *is* the allocation
	mark. What lies past the last live object is memory the image has not used yet."

	| walk |
	self assert: dumped youngSpaceStart isNotNil.
	self assert: dumped youngSpaceStart < dumped heapStart.

	walk := dumped youngObjectsWalk.
	self assert: walk objectCount > 100.
	self assert: walk stoppedAt < dumped heapStart.
	self assert: walk reason equals: #nothingButFreeSpace
