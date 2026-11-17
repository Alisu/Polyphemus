reading the class table
classIndexLimitFrom: anAddress

	"One past the largest class index VMMaker accepts in the heap starting here: a page's size by
	its count of class table pages, which stops at the first nil after the second
	(setHiddenRootsObj:). nil where the hidden roots are not where the heap says."

	| hiddenRoots header slots used |
	hiddenRoots := self hiddenRootsFrom: anAddress.
	header := hiddenRoots ifNotNil: [ self headerAt: hiddenRoots ].
	slots := header ifNotNil: [ self slotsAt: hiddenRoots header: header ].
	(slots notNil and: [
		 (self formatIn: header) = 2 and: [ slots >= self classTableRootSlots ] ]) ifFalse: [ ^ nil ].
	used := (3 to: self classTableRootSlots)
		        detect: [ :index | (self slotOf: hiddenRoots at: index) = anAddress ]
		        ifNone: [ self classTableRootSlots + 1 ].
	^ used - 1 * self classTablePageSize
