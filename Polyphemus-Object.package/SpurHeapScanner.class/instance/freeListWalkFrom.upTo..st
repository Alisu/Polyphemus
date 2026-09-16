reading the free lists
freeListWalkFrom: anAddress upTo: aLimit

	"Follow the allocator's own lists and answer what they account for.

	This reads the lists as ordinary slots rather than through the VM, on purpose: a checker
	that needs the memory to be loadable is no use on the memory that would not load. It is
	also why nothing here asks the memory manager anything."

	| walk listsObject |
	walk := SpurFreeListWalk new.
	listsObject := self freeListsObjectFrom: anAddress.
	(listsObject notNil and: [
		 (self formatIn: (self headerAt: listsObject)) = 9 and: [
			 (self slotsAt: listsObject) = self numberOfFreeLists ] ]) ifFalse: [
		walk problem: #freeListsAreNotWhereTheHeapSaysTheyAre at: anAddress.
		^ walk ].

	2 to: self numberOfFreeLists - 1 do: [ :index |
		self
			followFreeChainAt: (self slotOf: listsObject at: index + 1)
			expecting: index * 8
			from: anAddress
			upTo: aLimit
			into: walk ].
	self
		followFreeTreeAt: (self slotOf: listsObject at: 1)
		from: anAddress
		upTo: aLimit
		into: walk.
	^ walk
