tests
testWhatPharoCallsSelectsOnlyTheTestsNamingItsClass

	"Pharo's debugger calls syntaxHighlighter on our classes; nothing of ours does. Followed through
	every reference to OOPAbstractClass, at the heart of reification, it reached nearly every test."

	| selected |
	selected := self selectedFor: #( 'OOPAbstractClass syntaxHighlighter' ).
	self deny: (selected includes: #SpurHeapScannerTest).
	self assert: selected size < 20
