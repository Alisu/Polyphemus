tests
testACommonSelectorIsLeftToTheWholeSuite

	"Followed, #name would select whatever sends it, which is everything: said wide, and left
	to CI, which runs the whole suite."

	| impact |
	impact := TestImpact fromLines: #( 'Polyphemus name' ).
	self assert: (impact wideSelectors includes: #name).
	self assert: impact testClasses isEmpty
