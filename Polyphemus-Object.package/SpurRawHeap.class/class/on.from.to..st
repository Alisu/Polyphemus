instance creation
on: anAddressSpace from: anAddress to: aLimit

	"Noted for the tests that check every heap they read (#141)."

	| heap |
	heap := self new
		        setSpace: anAddressSpace from: anAddress to: aLimit;
		        yourself.
	SpurHeapWatch note: heap.
	^ heap
