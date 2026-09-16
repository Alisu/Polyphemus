reading the class table
classTableProblemsFrom: anAddress upTo: aLimit

	"Everything wrong with the table that turns a class index into a class.

	This is the structure whose damage is quietest. A broken free list eventually crashes
	something; a broken class table just answers the wrong name, for every object of that
	class, and nothing anywhere says so. So it is worth checking even though it is rarely
	the thing that failed.

	Only the pages in use are looked at -- an unused one holds nil, which is the first
	object of the heap."

	| problems hiddenRoots pages |
	problems := OrderedCollection new.
	hiddenRoots := self hiddenRootsFrom: anAddress.
	(hiddenRoots notNil and: [
		 (self formatIn: (self headerAt: hiddenRoots)) = 2 and: [
			 (self slotsAt: hiddenRoots) >= self classTableRootSlots ] ]) ifFalse: [
		problems add: #hiddenRootsAreNotWhereTheHeapSaysTheyAre -> anAddress.
		^ problems ].

	pages := self classTableRootSlots min: (self slotsAt: hiddenRoots).
	1 to: pages do: [ :index |
		| page |
		page := self slotOf: hiddenRoots at: index.
		(page = anAddress or: [ page = 0 or: [ page isNil ] ]) ifFalse: [
			problems size < 50 ifTrue: [
				(page between: anAddress and: aLimit)
					ifFalse: [ problems add: #classTablePageOutsideTheHeap -> page ]
					ifTrue: [
						(self slotsAt: page) = self classTablePageSize
							ifFalse: [ problems add: #classTablePageIsTheWrongSize -> page ]
							ifTrue: [
								self
									classesOfPage: page
									from: anAddress
									upTo: aLimit
									into: problems ] ] ] ] ].
	^ problems
