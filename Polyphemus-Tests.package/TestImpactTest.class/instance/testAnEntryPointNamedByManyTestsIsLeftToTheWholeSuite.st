tests
testAnEntryPointNamedByManyTestsIsLeftToTheWholeSuite

	"debugDeepestProcessIn:fixing: is for users: nothing calls it. The tests naming Polyphemus,
	nearly all, say nothing of it: Polyphemus is said wide, the whole suite left to CI."

	| impact |
	impact := TestImpact fromLines: #( 'Polyphemus debugDeepestProcessIn:fixing:' ).
	self assert: impact testClasses size < 10.
	self assert: (impact wideSelectors includes: #Polyphemus)
