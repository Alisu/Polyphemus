reading the class table
classTableProblemsFrom: anAddress upTo: aLimit

	"Everything wrong with the table that turns a class index into a class, as
	reason -> where. Structural problems carry the address that is wrong; a bad entry
	carries the *class index* it sits at, because that is what identifies the classes you
	will not be able to name.

	This is the structure whose damage is quietest. A broken free list eventually hands out
	memory that is in use and something falls over; a broken class table just answers the
	wrong name, and nothing anywhere says so.

	Only pages in use are looked at -- an unused one holds nil, the first object of the
	heap."

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
									numbered: index - 1
									from: anAddress
									upTo: aLimit
									into: problems ] ] ] ] ].
	^ problems
