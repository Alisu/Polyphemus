inspection
inImageItemsByName

	"Each named variable by its name, then each indexed slot by its number."

	| names |
	names := self oopClass allOopSlotNames.
	^ (names collectWithIndex: [ :name :index | name asString -> (self reifiedSlotAt: index) ]) asOrderedCollection
		  addAll: ((names size + 1 to: self oopNumberOfSlots) collect: [ :index |
				   (index - names size) printString -> (self reifiedSlotAt: index) ]);
		  yourself
