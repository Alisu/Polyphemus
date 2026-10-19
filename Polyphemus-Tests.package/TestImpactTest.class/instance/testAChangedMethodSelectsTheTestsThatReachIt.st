tests
testAChangedMethodSelectsTheTestsThatReachIt

	"Its senders, and theirs, up to the tests: not every test naming its class."

	| selected |
	selected := self selectedFor: #( 'Polyphemus deepestProcessIn:' ).
	self assert: (selected includes: #ProcessChoiceTest).
	self assert: (selected includes: #PolyphemusTest).
	self deny: (selected includes: #SpurHeapScannerTest)
