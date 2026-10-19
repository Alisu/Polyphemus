tests
testAChangedHelperOfTheTestsSelectsThoseUsingIt

	| selected |
	selected := self selectedFor: #( 'LiveImageTestCase launchSpinningTarget' ).
	self assert: (selected includes: #LiveRunUntilTest).
	self deny: (selected includes: #SpurHeapScannerTest)
