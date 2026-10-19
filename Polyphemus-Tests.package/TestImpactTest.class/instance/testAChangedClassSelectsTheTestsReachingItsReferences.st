tests
testAChangedClassSelectsTheTestsReachingItsReferences

	"A class redefined or new: its references stand for its senders."

	| selected |
	selected := self selectedFor: #( 'ProcessMemoryCopy' ).
	self assert: (selected includes: #ProcessMemoryCopyTest).
	self deny: (selected includes: #SpurHeapScannerTest)
