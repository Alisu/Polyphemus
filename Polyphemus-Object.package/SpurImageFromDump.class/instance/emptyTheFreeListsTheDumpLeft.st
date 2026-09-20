writing
emptyTheFreeListsTheDumpLeft

	"The dump's free lists describe its trailing free space, which VMMaker's initialization
	describes again: emptied, so that it is described once."

	| freeLists |
	freeLists := dumped raw scanner objectAfter: dumped raw heapStart + 32.
	0 to: 63 do: [ :each |
		dumped memory storePointerUnchecked: each ofObject: freeLists withValue: 0 ]
