reading the class table
classTableProblemsFrom: anAddress upTo: aLimit

	"Class table problems, as reason -> address when structural, or reason -> class index for
	a bad entry. Only pages in use are checked."

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
