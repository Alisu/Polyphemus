reading the class table
classIndexLimitFrom: anAddress

	"One past the largest class index VMMaker accepts in the heap starting here: a page's size by
	its count of class table pages, which stops at the first nil after the second
	(setHiddenRootsObj:). nil where the hidden roots are not where the heap says."

	| hiddenRoots header used |
	hiddenRoots := self hiddenRootsFrom: anAddress.
	header := hiddenRoots ifNotNil: [ self headerAt: hiddenRoots ].
	(header notNil and: [
		 (self formatIn: header) = 2 and: [ (self slotsAt: hiddenRoots) >= self classTableRootSlots ] ]) ifFalse: [ ^ nil ].
	used := (3 to: self classTableRootSlots)
		        detect: [ :index | (self slotOf: hiddenRoots at: index) = anAddress ]
		        ifNone: [ self classTableRootSlots + 1 ].
	^ used - 1 * self classTablePageSize
